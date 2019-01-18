# Lab8. ICP上での Mircroclimate の実行

このLabでは、ICP上で Microclimate を実行して、新規Java マイクロサービス・アプリケーションを開発していく手順を確認します。

## 前提

この　Labでは、下記の準備を前提としています。
- Microclimate は、製品版の IBM Cloud Privateで提供されている機能です。
- インターネットに接続できる環境
- ICP環境に用意されているリソースが 8Core/16GB の場合には、快適に操作ができない可能性があります。必要に応じてリソースを増強ください。
- 参考： [Microclimate ドキュメント](https://microclimate-dev2ops.github.io) 

所用時間は、およそ60分です。

## Microclimate 導入前準備

1. ICP環境にログオンします。
    1. ブラウザで指定されたインスタンスの ICP環境のコンソールを開きます。<br>
        https://<ICP_ClusterIP:8443/icp/console<br> 
        認証情報　admin : admin<br>
    1. 右上のメニューから「カタログ」を選択し、ICPのソリューション・カタログのページを開きます
    1. カタログの画面で検索バーに「microclimate」を入力し、絞り込まれた「ibm-microclimate」のアイコンをクリックし、Micloclmate のHELMチャートを開きます。
    1. 「Micloclmate」のチャートに表示されている README を確認し、導入手順を確認します。導入手順は、HELMのリリースが上がった場合に追加のステップが必要となる可能性があります。ここでは、執筆時点の最新である v1.9.0 をもとに 導入手順を記載します。

## Microclimate 導入前準備： 名前空間とイメージ・ポリシー
   1. この手順では、Micloclimate自体は、これまで利用してきた `handson` 名前空間に払い出しを行います
   1. ターゲット名前空間の作成
        Microclimate 内のJenkins Pipelineから、ビルドされたコンテナを払い出すようの 名前空間を `microclimate-pipeline-deployments`という名前で作成します。任意の名前でも結構です。
        ```
        # kubectl create namespace microclimate-pipeline-deployments
        ```
   1. ImagePolicy の作成
        ICPでは IBM Security Enforcement機能がデフォルトで有効になっており、指定された イメージ・レポジトリからしかコンテナ・イメージをロードできません。Microclimateはデフォルトで許可された以外のコンテナも利用するため、新規にこれを許可する `ImagePocy` を作成します。ハンズオンでは便宜上クラスター・レベルで`ImagePolicy`を作成しますが、名前空間レベルでも作成可能です。
        ```
        apiVersion: securityenforcement.admission.cloud.ibm.com/v1beta1
        kind: ClusterImagePolicy
        metadata:
            name: microclimate-cluster-image-policy
        spec:
            repositories:
            - name: <cluster_ca_domain>:8500/*
            - name: docker.io/maven:*
            - name: docker.io/jenkins/*
            - name: docker.io/docker:*
        ```

## Microclimate 導入前準備： 認証情報の作成
1. ICPイメージ・レポジトリにアクセスするための認証情報 (handson名前空間用）<br>
Microclimate がICP内のイメージ・レポジトリにアクセスするための認証情報を Secretとして作成します。以下のコマンドで、Secret を作成します。
    ```
    kubectl create secret docker-registry microclimate-registry-secret --docker-server=mycluste.icp:8500 --docker-username=admin --docker-password=admin --docker-email=sample@address.mail -n handson
    ```
1. ICPイメージ・レポジトリにアクセスするための認証情報 (microclimate-pipeline-deployments名前空間用）<br>
Microclimateが Jenkinsパイプラインから、ICP内のイメージ・レポジトリにアクセスするための認証情報を Secretとして作成します。
    ```
    kubectl create secret docker-registry microclimate-pipeline-secret --docker-server=mycluste.icp:8500 --docker-username=admin --docker-password=admin --docker-email=sample@address.mail -n microclimate-pipeline-deployments
    ```
1. HELMのTillerにアクセスするための認証情報<br>
Microclimate のJenkins Pipelineの中から、HELMコマンドを利用して実際にデプロイを行います。この際に、HELMのTillerにアクセスするための認証情報です。
    1. 以下のコマンドでログインします。最後に、HEML_HOME が `Configuring helm: /root/.helm` のような形で、出力されていますので確認してください。
       ```
       # cloudctl login -a https://mycluster.icp:8443
       ```
   1. 環境変数 HELM_HOME を設定します
       ```
       # HELM_HOME="/root/.helm"
       ```
   1. `ls -l $HELM_HOME`を実行し、当該ディレクトリに `ca.pem``cert.pem``key.pem`などの鍵があることを確認してください。
   1. 以下のコマンドでSecret を作成します。
        ```
        kubectl create secret generic microclimate-helm-secret --from-file=cert.pem=$HELM_HOME/cert.pem --from-file=ca.pem=$HELM_HOME/ca.pem --from-file=key.pem=$HELM_HOME/key.pem
        ```
   1. `default` サービス・アカウントに作成した Secret を関連付けます
        ```
        # kubectl patch serviceaccount default --namespace microclimate-pipeline-deployments -p "{\"imagePullSecrets\": [{\"name\": \"microclimate-pipeline-secret\"}]}"
        ```
## Microclimate 導入前準備： Persitent Volumeの作成
    Microclimateは、２つのPersistence Volume を必要とします。
1. ハンズオン環境では１VMしかないため、`HostPath`を PersitentVolumeとして利用します。以下のコマンドで、PersitentVolumeとして利用されるディレクトリを作成してください。
    ```
    # mkdir -p /work/lab8/microclimate
    # mkdir -p /work/lab8/jenkins
    ```
1. Microclimate用 Persitent Volume 定義の作成
     1. 以下の内容のyamlファイルを、ibm-microclimate-pv.yamlという名前で作成してください。
        ```
        apiVersion: v1
        kind: PersistentVolume
        metadata:
          name: ibm-microclimate
        spec:
          capacity:
            storage: 8Gi
          accessModes:
            - ReadWriteMany
          persistentVolumeReclaimPolicy: Retain
          hostPath:
            path: /work/lab8/microclimate
        ```
     1. 以下のコマンドで、Microclimate用 Persitent Volumeを作成します
        ```
        kubectl apply -f /work/lab8/ibm-microclimate-pv.yaml
        ```
1. 同様に、 Microclimate Jenkins用 Persitent Volume 定義の作成
     1. 以下の内容のyamlファイルを、ibm-microclimate-jenkins-pv.yamlという名前で作成してください。
        ```
        apiVersion: v1
        kind: PersistentVolume
        metadata:
          name: microclimate-jenkins
        spec:
          capacity:
            storage: 8Gi
          accessModes:
            - ReadWriteOnce
          persistentVolumeReclaimPolicy: Retain
          hostPath:
            path: /work/lab8
         ```
      1. 以下のコマンドで、Microclimate用 Persitent Volumeを作成します     
         ```
         kubectl apply -f /work/lab8/ibm-microclimate-jenkins-pv.yaml
         ```
        
1. Microclimateの導入
    
    1. ICP GUIコンソール上の、Microclimate の HELMチャートに戻り「構成」のボタンをクリックします。以下を指定します。
         
         **構成**
         * HELMリリース名： microclimate
         * ターゲット名前空間： handson
         * 使用許諾条件： チェックを入れる
         
         **パラメータ**
         * Microclimate Ingress domain ： <ICPサーバーのIPアドレス>.nip.io
         
         **すべてのパラメータ**
         * Dynamic provisioning： チェックを外す
         す。
    1. 「インストール」ボタンをクリックします。HELMの導入が始まります。
    1. HELMインスタンスのページに移動し、`microclimate`を探します。
    1. ４つの Deployment すべてが `利用可能` になっていることを確認します。
    
    これで、Microclimate の導入は完了です。


## Microclimate 環境の確認

1. ICP環境にログオンし、Microclimate を開きます。
    1. ブラウザで指定されたインスタンスの ICP環境のコンソールを開きます。<br>
        https://microclimate.<ICP_Proxy_Adress>.nip.io 
        認証情報　admin : admin<br>  ※ログインしていない場合は、ICPの認証情報でログインしてください。
        )

## 新規Java プロジェクトの作成

1. 新規にJavaのマイクロサービス・プロジェクトを作成します。画面の下にある「新規プロジェクト」ボタンをクリックします。
下の画面には幾つかのプロジェクトがすでに存在しますが、最初はプロジェクトが存在しません。
![microclimate01](https://github.com/ICpTrial/ICPLab/blob/master/mcimage/microclimate01.png)
1. 作成するプロジェクトの言語として「Java」を選択し、プロジェクト名 「labproject01」を指定します。
 ![microclimate03](https://github.com/ICpTrial/ICPLab/blob/master/mcimage/microclimate03.png)
1. Javaアプリケーションのフレームワークを選択します。ここでは、「Microprofile/JavaEE」を指定します。
 ![microclimate04](https://github.com/ICpTrial/ICPLab/blob/master/mcimage/microclimate04.png)
1. Javaアプリケーションのコンテキストルートを指定します。デフォルトではプロジェクト名が入ります。ここではそのままにし、「作成」をクリックします。
 ![microclimate05](https://github.com/ICpTrial/ICPLab/blob/master/mcimage/microclimate05.png)
1. 以下のようなプロジェクトが作成され、自動生成されたアプリケーションをベースにアプリケーションおよびコンテナのビルドが走ります。
　 しばらくお待ち下さい。
 ![microclimate06](https://github.com/ICpTrial/ICPLab/blob/master/mcimage/microclimate06.png)
 
## 作成された プロジェクトの確認
1. 自動生成されたプロジェクトを確認していきます。「コードの編集」を開きます。
 ![microclimate07](https://github.com/ICpTrial/ICPLab/blob/master/mcimage/microclimate07.png)
    1. src配下に 自動生成された非常にシンプルなアプリケーションが配置されています。<br>
    これは、REST API で GETで呼ばれた場合に、メッセージを返すのみのシンプルなものです。
    ![microclimate08](https://github.com/ICpTrial/ICPLab/blob/master/mcimage/microclimate08.png)
    1. またアプリケーションには、Microprofileで定められた アプリケーションの正常性を確認するための HealthEndpoint.java も定義されています。
    1. アプリケーションの下には、Libety の構成ファイル (liberty¥config）が生成されています。<br>
    本体である `server.xml` や、環境変数を設定するための `server.env`、jvm引数として渡すための `jvm.options` などのファイルがあります。
    1. webapp の下には、WEB-INF下に配置される各種定義ファイルが配置されています。
    1. その他、アプリケーションのルートディレクトリには、コンテナをビルドするための `Dockerfile` が定義されています。<br>
    このファイルを使って、コンテナのビルドが行われます。
    1. Readme.md は、GitHubにこのアプリケーションが登録された際に、ReadMeとして表示される MarkupDocument です。<br>
    お客様環境に適宜あわせて利用します。
1. コンテナーのビルドのログを確認するには、「ビルド・ログ」をクリックします。
1. 実際のアプリケーションが稼働しているか確認するには、「アプリケーションを開く」をクリックします。
![microclimate09](https://github.com/ICpTrial/ICPLab/blob/master/mcimage/microclimate09.png)
1. コンテナ・アプリケーション（Liberty）のログを確認するには、「アプリケーション・ログ」をクリックします。
![microclimate10](https://github.com/ICpTrial/ICPLab/blob/master/mcimage/microclimate10.png)
1. コンテナ・アプリケーション（Liberty）のリソースの利用状況を確認しながら、開発を実施することができます。<br>
「アプリケーション・モニター」をクリックします。
![microclimate11](https://github.com/ICpTrial/ICPLab/blob/master/mcimage/microclimate11.png)


## 作成された プロジェクトをGit に登録します。

ハンズオンで使用するレポジトリ<br>
  1人目　https://github.com/ICpTrial/lab501<br>
  2人目　https://github.com/ICpTrial/lab502<br>
  予備　 https://github.com/ICpTrial/lab503<br>
    
1. Terratermを利用して、ICPサーバーにログインします。このハンズオン環境は単体のK8S環境ですので、ローカル・ディレクトリにPersitentVolumeが構成されています。作成されたプロジェクトのroot ディレクトリにおいて、以下のコマンドを実行して、作成されたプロジェクトを Git レポジトリに登録します。<br>
`cd /work/microclimate/admin/labproject01`<br>
`git init`<br>
`git add .`<br>
`git remote add mygitrepos https://github.com/ICpTrial/labxxx` GitHubはそれぞれのものを利用してください<br> 
`git push --set-upstream mygitrepos master`

1. Git利用したGitHub を開いて登録されているかご確認ください。

## Jenkinsパイプラインとの関連付け
パイプラインの機能を利用して、このアプリケーションに、Jenkinsを利用したCI/CDの仕組みを関連付けます。
1. 一番下にある「パイプライン」を開き、「パイプラインの作成」をクリックします。
![pipeline01](https://github.com/ICpTrial/ICPLab/blob/master/mcimage/pipeline01.png)
1. パイプラインの名前および このアプリケーションが管理される GitレポジトリのURLを指定します。<br>

![pipeline02](https://github.com/ICpTrial/ICPLab/blob/master/mcimage/pipeline02.png)
1. 「資格情報の選択」をクリックし、このGitレポジトリにアクセスするための情報（ユーザーID&パスワードまたはTOKEN)を定義し、「パイプラインの作成」をクリックします。認証情報はハンズオン実施者に確認ください。
![pipeline03](https://github.com/ICpTrial/ICPLab/blob/master/mcimage/pipeline03.png)
1. 「デプロイメントの追加」をクリックし、ここでは、デフォルトのまま Master のブランチを追加します。
![pipeline06](https://github.com/ICpTrial/ICPLab/blob/master/mcimage/pipeline06.png)
1. パイプラインが作成されるので、パイプラインを開くをクリックします。
![pipeline04](https://github.com/ICpTrial/ICPLab/blob/master/mcimage/pipeline04.png)
1. このアプリケーションに関連付けられたJenkinsが開きます。
![pipeline07](https://github.com/ICpTrial/ICPLab/blob/master/mcimage/pipeline07.png)
1. masterパイプライン でのビルドおよびデプロイの状況を確認します。
![pipeline08](https://github.com/ICpTrial/ICPLab/blob/master/mcimage/pipeline08.png)
1. ICPのコンソールに入り、ワークロード > デプロイメントを選択し、名前空間「microclimate-pipeline-deployments」を選択し、デプロイメントが行わていることを確認します。
![pipeline09](https://github.com/ICpTrial/ICPLab/blob/master/mcimage/pipeline09.png)


以上で、Lab8は終了です。
