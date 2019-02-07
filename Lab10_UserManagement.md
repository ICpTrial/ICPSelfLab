# Lab10. ImagePolicy と ICPでのユーザー管理

ICPで admin ユーザー以外を追加するためには、LDAPとの連携が必要になります。
LDAPを通じてユーザーをICPに連携した上で、そのユーザーをチームに編成し、それぞれのユーザーのアクセス権限を設定します。
また、あわせて ICP3.1.1からデフォルトで構成されている IBM ClusterImagePolicy / ImagePolicy の挙動も確認します。

このLabでは、ICP環境とLDAPを連携させ、複数ユーザーで ICPを管理できるようにします。

## 前提

このハンズオンは、ICPがインストールされたあとであれば任意のタイミングで実施可能です。
ハンズオンのため便宜的に連携先のLDAPとしては、コンテナベースで提供される openldap を利用します。

所用時間は、およそ20分です。

## ICP HELMテンプレートの作成とインポート、および IBM ImagePolicy の構成

1. openldap helmチャートの準備

    1. 以下のコマンドで、openldap の helmチャートを入手してください。
      ```
      mkdir -p /work/lab10
      cd /work/lab10
      git clone https://github.com/ibm-cloud-architecture/icp-openldap.git 
      ```
    1. デフォルトで作成されるユーザーなどが values.yaml に定義されていますので、必要に応じてパスワード変更、ユーザー追加を実施します。
    ```
    # cat /work/lab10/icp-openldap/values.yaml
    OpenLdap:
    Image: "docker.io/osixia/openldap"
    ImagePullPolicy: "Always"
    Component: "openldap"

    Replicas: 1

    Cpu: "512m"
    Memory: "200Mi"

    Domain: "local.io"                      ## 必要に応じて編集
    AdminPassword: "admin"                  ## 必要に応じて編集
    Https: "false"                          ## 必要に応じて編集
    SeedUsers:
    usergroup: "icpusers"                   ## 必要に応じて編集
    userlist: "user1,user2,user3,user4"     ## 必要に応じて編集
    initialPassword: "ChangeMe"             ## 必要に応じて編集

    PhpLdapAdmin:
    Image: "docker.io/osixia/phpldapadmin"
    ImageTag: "0.7.0"
    ImagePullPolicy: "Always"
    Component: "phpadmin"

    Replicas: 1

    NodePort: 31080

    Cpu: "512m"
    Memory: "200Mi"
    ```
    1. helmチャートをパッケージします。
      ```
      helm package icp-openldap
      Successfully packaged chart and saved it to: /work/icp-openldap-0.1.5.tgz
      ```
1. ICPのhelmレポジトリへの登録

    1. ICPにログインしていなければログインしてください。ネームスペースには、とりあえず`default` を選びます。
      ```
      # cloudctl login -a https://mycluster.icp:8443 --skip-ssl-validation
      ```
    1. icp-openldap の HELMチャートをアップロードします。
      ```
      # cloudctl catalog load-helm-chart -archive /work/lab10/icp-openldap-0.1.5.tgz
      Helm チャートのロード中
      ロードされた Helm チャート

      チャートの同期
      同期が開始されました
      OK
      ```
1. Cluster Image Policyの設定    
    1. IBM Custer Image Policy の設定
    icp-openldap のHELMチャートを導入していきますが、デフォルトではこの helmチャートで利用される イメージが許可されていないため以下のようなエラーが発生して、導入に失敗します。試しにHELMを実行して、エラーを確認してみましょう（確認したあとは 失敗したhelmインスタンスを削除しておきます）。
    ```
    # helm install icp-openldap-0.1.5.tgz --name openldap --namespace default --tls
    Error: release openldap failed: Internal error occurred: admission webhook    
    "trust.hooks.securityenforcement.admission.cloud.ibm.com" denied the request:
    Deny "docker.io/osixia/openldap:1.1.10", no matching repositories in ClusterImagePolicy and no ImagePolicies in the "default" namespace
    # helm delete openldap --purge --tls
    release "openldap" deleted
    ```
    1. Image Policy を確認します。ImagePolicy は クラスターレベルの ClusterImagePolicy と ネームスペースレベルの ImagePolicy があります。
    ```
    root@icp21master:/work/lab10# kubectl get clusterimagepolicy
    NAME                                    AGE
    ibmcloud-default-cluster-image-policy   135d
    root@icp21master:/work/lab10# kubectl get imagepolicy -n default
    No resources found.
    ```
    1. デフォルトの ClusterImagePolicy の設定を以下のコマンドで確認してみてください。
    ```
    # kubectl describe clusterimagepolicy
    ```
    1. ネームスペース・レベルの ImagePolicy を、以下の内容で yaml ファイルを定義します。
    ```
    apiVersion:  securityenforcement.admission.cloud.ibm.com/v1beta1
    kind: ImagePolicy
    metadata:
      name: lab-image-policy
    spec:
      repositories:
        - name:  docker.io/osixia/openldap:*
        - name:  docker.io/osixia/phpldapadmin:*
    ```
    1. 実際にImagePolicyを作成します。
    ```
    # kubectl apply -f lab-image-policy.yaml -n default
    imagepolicy.securityenforcement.admission.cloud.ibm.com/lab-image-policy created
    ```
    1. 作成された ImagePolixy を 確認してみましょう。
    ```
    root@icp21master:/work/lab10# kubectl get imagepolicy -n default
    NAME               AGE
    lab-image-policy   3m
    root@icp21master:/work/lab10# kubectl describe imagepolicy lab-image-policy -n default
    Name:         lab-image-policy
    Namespace:    default
    Labels:       <none>
    Annotations:  kubectl.kubernetes.io/last-applied-configuration={"apiVersion":"securityenforcement.admission.cloud.ibm.com/v1beta1","kind":"ImagePolicy","metadata":{"annotations":{},"name":"lab-image-policy","namesp...
    API Version:  securityenforcement.admission.cloud.ibm.com/v1beta1
    Kind:         ImagePolicy
    Metadata:
      Creation Timestamp:  2019-02-05T02:22:37Z
      Generation:          1
      Resource Version:    29881155
      Self Link:           /apis/securityenforcement.admission.cloud.ibm.com/v1beta1/namespaces/default/imagepolicies/lab-image-policy
      UID:                 e7a204ea-28ec-11e9-bddb-06ab180ab7fe
    Spec:
      Repositories:
        Name:  docker.io/osixia/openldap:*
        Name:  docker.io/osixia/phpldapadmin:*
    Events:    <none>
    ```
    
1. OpenLDAP HelmChart の導入
   1. 実際にHELMをインストールしていきます。    
    ```
    # helm install icp-openldap-0.1.5.tgz --name openldap --namespace default --tls
    ```
   1. `helm status`コマンドで、正常に導入できたか確認しましょう。
    ```
    root@icp21master:/work/lab10# helm status openldap  --tls
    LAST DEPLOYED: Tue Feb  5 02:32:31 2019
    NAMESPACE: default
    STATUS: DEPLOYED

    RESOURCES:
    ==> v1/ConfigMap
    NAME                DATA  AGE
    openldap-seedusers  1     56s

    ==> v1/Service
    NAME            TYPE       CLUSTER-IP  EXTERNAL-IP  PORT(S)       AGE
    openldap        ClusterIP  10.0.0.219  <none>       389/TCP       56s
    openldap-admin  NodePort   10.0.0.227  <none>       80:31080/TCP  56s

    ==> v1beta1/Deployment
    NAME            DESIRED  CURRENT  UP-TO-DATE  AVAILABLE  AGE
    openldap        1        1        1           1          56s
    openldap-admin  1        1        1           1          56s

    ==> v1/Pod(related)
    NAME                             READY  STATUS   RESTARTS  AGE
    openldap-6bf68c67b9-p2x4b        1/1    Running  0         56s
    openldap-admin-5f5d475bd8-9r8tg  1/1    Running  0         56s
    ```
    
## LDAPの定義内容の確認
1. openldapの確認<br>
    ここは openldapの確認をしているだけですので、スキップ可能です。<br>
    なお 今回は openldapに PVが定義されていないので、管理画面からアクセスしてユーザーを追加しても、Podが再起動された場合データは失います。
    
    1. ICPのコンソールに入り、デプロイメントから `openldap-admin`を開きます。右上の`起動`ボタンをクリックします。
    1. Openldapデフォルトのphpの画面が開きますので、以下の情報でログインします。
       ```
       Login DN: cn=admin,dc=local,dc=io
       Password: admin
       ```
    1. LDAPで定義されている内容を確認してください。<br>
      ![phpLDAP管理画面](https://github.com/ICpTrial/ICPSelfLab/blob/master/images/Lab10/ldaptop.png)
  
## ICPとLDAPの連携
1. LDAPの定義
    1. ICPのコンソールにログインし、左のメニューから 管理 > IDおよびアクセス を開きます。
    1. 認証を開き、中央の `接続のセットアップ`のリンクをクリックします。
    1. 以下の情報をもちいて、LDAP接続の定義を構成し、保管を行います。
        ```
        ①LDAP接続　名前： labldap  タイプ：カスタム
        ②LDAP認証　基本DN：dc=local,dc=io　バインドDN：cn=admin,dc=local,dc=io　DNパスワードの設定： admin
        ③LDAPサーバー　URL： ldap://10.0.0.219:389      
            HELMの一覧で表示された openldap の clsuterIPを指定します。
            ここまで設定したら、「接続のテスト」をクリックして、接続が正しいか確認してください。
        ④LDAPフィルター
         グループ・フィルター：(&(cn=%v)(objectclass=groupOfUniqueNames))
         ユーザー・フィルター：(&(uid=%v)(objectclass=person))
         グループID： *:cn
         ユーザーID： *:uid
         グループ・メンバー ID マップ：groupOfUniqueNames:uniquemember
        ```
1. ユーザーのインポートとチームへの編成
    1. チームを開き、「チームの作成」をクリックします。
    1. チーム名として `lab team`を指定します。
    1. ユーザー・タブを開き、`user`と入力します。<br>
       LDAPに登録されたユーザーがリストされますので、選択して、以下の通りそれぞれ役割を割り当て、「作成」をクリックします。
       ![ユーザー登録](https://github.com/ICpTrial/ICPSelfLab/blob/master/images/Lab10/labteam.png)
    1. 作成された `lab team`のリンクを開き、`リソース`タブを開き「リソースの管理」をクリックします。
    1. アクセスを許可する 名前スペースと helmレポジトリにチェックを入れます。<br>
       ここでは 名前空間 `lab-space` と ibm-chartの中の `ibm-nodejs-sample` だけを設定します。
    1. 設定を確認して、「保存」をクリックします。
    
1. 各ユーザーでのログイン
  

    
    
