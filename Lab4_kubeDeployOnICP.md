# Lab4. 独自のDockerイメージをICPにデプロイ

このLabでは、Lab2.で作成した独自のWebSphere LibertyのDockerイメージを、ICPにデプロイします。Helmチャートを使用してデプロイするのではなく、Kubernetesのオブジェクトを一つずつ作成していきます。

## 前提

この　Labでは、下記の準備を前提としています。

- kubectlコマンドのインストール<br>
    [ICP Knowledge Center: kubectl CLI からクラスターへのアクセス](https://www.ibm.com/support/knowledgecenter/ja/SSBS6K_3.1.0/manage_cluster/cfc_cli.html)
    ICPコンソールの[Command Line Tools]>[Cloud Private CLI]の[Install Kubectl CLI]の項目も参照ください

所用時間は、およそ40分です。

## ハンズオン環境の確認

1. コマンド・プロンプトを起動します。
1. このLabの作業ディレクトリー (C:¥Handson¥Lab4) に移動します。このディレクトリーには、下記のファイルが事前に準備されています。
    - mylibapp-deployment.yaml : デプロイメント作成時の定義ファイル
    - mylibapp-nodeportservice.yaml : サービス(NodePort)作成時の定義ファイル
    - mylibapp-ingress.yaml : Ingress作成時の定義ファイル

## LibertyイメージをICPのプライベート・レジストリーにPush(アップロード)

(参照)
[ICP KnowledgeCenter: イメージのプッシュおよびプル](https://www.ibm.com/support/knowledgecenter/ja/SSBS6K_3.1.0/manage_images/using_docker_cli.html)

1. ICPのプライベート・レジストリーへの接続/認証の確認
    ICPのプライベート・レジストリーに、Dockerイメージを直接アップロード(docker push)するには、ICPのプライベート・レジストリーにdocker loginする必要があります。<br>
    `docker login <cluster_CA_domain>:8500` (デフォルトでは、`docker login mycluster.icp:8500`) コマンドを入力します。
    /etc/hostsファイルで名前解決されるようになっていますので、<cluster_CA_domain>のホスト名が、ICPのマスター・ノードのIPアドレスに解決されます。
    UsernameとPasswordの入力が求められますので、ICPの管理者ユーザーのユーザー名(デフォルト:admin)とパスワードを入力します。
    ```
    $ docker login mycluster.icp:8500
    Username: admin
    Password: 
    Login Succeeded
    $ 
    ```
1. アップロードするイメージの確認
    `docker images` コマンドを入力し、Lab2. で作成した「mylibertyapp:1.0」のイメージがローカルのDockerレジストリーに存在することを確認します。
    ```
    $ docker images
    REPOSITORY                                   TAG                 IMAGE ID            CREATED             SIZE
    mylibertyapp                                 1.0                 4027ff6ba2c0        15 hours ago        508MB
    $ 
    ```
    
1. アップロードするイメージの名前の変更(追加)
　　ICPで管理されるイメージを 名前空間でのみアクセス可能とするには、指定された形式でタグをつけて保管をします。
    `docker tag <source_image> <target_image>` コマンド(<source_image>に対して、<target_image>の別名を付与します)で、アップロードするイメージに"<Dockerレジストリーのホスト>/<名前空間>/<イメージ名>:<tag名>"の別名をつけます。<br>
    具体的には、'docker tag mylibertyapp:1.0 mycluster.icp:8500/handson/mylibertyapp:1.0' コマンドを入力します。
    ```
    $ docker tag mylibertyapp:1.0 mycluster.icp:8500/handson/mylibertyapp:1.0
    $ 
    ```
1. `docker images` コマンドを入力し、別名が付与されたイメージを確認します。
    ```
    $ docker images
    REPOSITORY                                   TAG                 IMAGE ID            CREATED             SIZE
    mylibertyapp                                 1.0                 4027ff6ba2c0        15 hours ago        508MB
    mycluster.icp:8500/handson/mylibertyapp  1.0                 4027ff6ba2c0        15 hours ago        508MB
    $ 
    ```
    同じIMAGE IDのエントリーが2行表示され、ここで追加した名前のエントリーがあることを確認します。

1. イメージをアップロードします。
    `docker push <image_name>:<tag>`コマンドで、ICPのDockerプライベート・レジストリーにイメージをアップロードします。具体的には、`docker push mycluster.icp:8500/handson/mylibertyapp:1.0` コマンドを入力します。
    ```
    $ docker push mycluster.icp:8500/handson/mylibertyapp:1.0
    The push refers to repository [mycluster.icp:8500/handson/mylibertyapp]
    f37d6997dbf5: Pushed 
    b59575289163: Pushed 
    cc9bdd0b2e77: Pushed 
    dbc56930e22a: Pushed 
    1156fc2732d2: Pushed 
    9653449ae0c0: Pushed 
    5835a439cd0f: Pushed 
    cdd1712a64a6: Pushed 
    29d653464649: Pushed 
    73b7e8535a4f: Pushed 
    23079eb1920d: Pushed 
    519f68f5a195: Pushed 
    a4a5449903ec: Pushed 
    f1dfa8049aa6: Pushed 
    79109c0f8a0b: Pushed 
    33db8ccd260b: Pushed 
    b8c891f0ffec: Pushed 
    1.0: digest: sha256:40c187d55d17fb07bbcc093aae5f159eecb43fb3aa3fbab8f6d19cc983b4918e size: 3878
    $ 
    ```
1. アップロードされたイメージをICPコンソールから確認します。
ICPコンソールにログインし、ナビゲーション・メニューから、[イメージ]を選択します。名前が"handson/mylibertyapp"のエントリーがあることを確認します。
![Image](https://github.com/ICpTrial/ICPLab/blob/master/images/Lab4/Lab4_01_Image.png)


## PC上のkubectlコマンドの接続先をICPに構成<br>

kubectlコマンドは、kubenetes標準のkubernetesクラスターを管理する標準のコマンドライン・ツールです。

1. ``cloudctl login``コマンドで ICP環境にログインします。デフォルトの名前空間を聞かれるので、ここでは handson を指定します。 
    ```
    # cloudctl login -a https://mycluster.icp:8443/
    
    Username> admin
    
    Password>
    Authenticating...
    OK
    
    Targeted account mycluster Account (id-mycluster-account)
    
    Select a namespace:
    1. cert-manager
    2. default
    3. handson
    4. ibmcom
    5. istio-enabled-namespace
    6. istio-system
    7. kube-public
    8. kube-system
    9. platform
    10. services
    Enter a number> 3
    Targeted namespace handson
    
    Configuring kubectl ...
    Property "clusters.mycluster" unset.
    Property "users.mycluster-user" unset.
    Property "contexts.mycluster-context" unset.
    Cluster "mycluster" set.
    User "mycluster-user" set.
    Context "mycluster-context" created.
    Switched to context "mycluster-context".
    OK
    
    Configuring helm: /root/.helm
    OK
    ```
    

1. kubectlコマンドの接続先が、ICPで構成されていることを確認します。`kubectl get nodes` コマンドを入力し、NAME欄に表示されるIPアドレスが、対象のICPのサーバーとなっていることを確認します。
    ```
    $ kubectl get nodes
    NAME           STATUS    ROLES                                    AGE       VERSION
    10.129.86.68   Ready     etcd,management,master,proxy,va,worker   20d       v1.11.1+icp-ee
    $ 
    ```
1. ICPのプライベート・レジストリーに保管されている"mylibertyapp"のイメージを、kubectlコマンドで確認してみます。`kubectl get images` コマンドを入力します。
    ```
    $ kubectl get images
    NAME           AGE
    mylibertyapp   55m
    $ 
    ```
    mylibertyappのイメージの存在が確認できます。今回、このkubectlは、"handson"の名前空間を対象にしてオブジェクトを表示しています。`--all-namespaces` オプションを付与することで、すべての名前空間のオブジェクトを表示することもできます。
    ```
    $ kubectl get images --all-namespaces
    NAMESPACE   NAME                                     AGE
    handson     mylibertyapp                             58m
    ibmcom      alertmanager-amd64                       20d
    ibmcom      calico-cni-amd64                         20d
    ibmcom      calico-kube-controllers-amd64            20d
    (以下略)
    ```
## kubectlコマンドを使用したデプロイメントの作成

kubectlコマンドで、kubernetesのオブジェクトを作成する場合、オブジェクトの定義情報を、yamlまたはjsonファイル形式で記述し、`kubectl apply -f <file_name>` コマンドで適用します。オブジェクトの新規作成も、オブジェクトの更新も、同じコマンドで実行できます。
1. デプロイメントを作成するためのyamlファイルを、Lab4ディレクトリーに準備しています。"mylibapp-deployment.yaml"をテキスト・エディターで開き、内容を確認します。
    ```yaml:mylibapp-deployment.yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: mylibertyapp-deploy
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: mylibertyapp
      template:
        metadata:
          labels:
            app: mylibertyapp
        spec:
          containers:
          - name: myliberty-container
            image: icpcluster01.icp:8500/handson/mylibertyapp:1.0
            ports:
            - containerPort: 9080
    ```
    上記のデプロイメントの定義ファイルでは、下記のような設定を記述しています。
    - 2行目の"kind: Deployment"で、デプロイメントの定義であることを指定
    - 6行目の"replicas: 1"で、ポッドの複製の数を指定
    - 17行目の"image: icpcluster01.icp:8500/handson/mylibertyapp:1.0"で、コンテナーのイメージを指定
1. `kubectl apply -f mylibapp-deployment.yaml` コマンドを入力し、デプロイメントを作成します。
    ```
    $ kubectl apply -f mylibapp-deployment.yaml
    deployment "mylibertyapp-deploy" created
    $ 
    ```
1. 作成したデプロイメントを確認します。`kubectl get deployments` または `kubectl get deploy` コマンドを入力し、"mylibertyapp-deploy"のエントリーが表示されることを確認します。
    ```
    $ kubectl get deploy
    NAME                       DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
    liberty-default-helm-ibm   1         1         1            1           8h
    mylibertyapp-deploy        1         1         1            1           2m
    $ 
    ```
    また、`kubectl get deploy mylibertyapp-deploy -o wide` や `kubectl get deploy mylibertyapp-deploy -o yaml` 、 `kubectl describe deploy mylibertyapp-deploy` コマンドでより詳細な情報も確認できます。
    また、デプロイメントの作成により、自動的にポッドが作成されます。'kubectl get pods' または 'kubectl get po' コマンドを入力し、"mylibertyapp-deploy"で始まるポッドが出力されることを確認します。
    ```
    $ kubectl get po  
    NAME                                        READY     STATUS    RESTARTS   AGE
    liberty-default-helm-ibm-6f6fc5fbfd-4khv8   1/1       Running   0          8h
    mylibertyapp-deploy-648c4645f9-dj5nv        1/1       Running   0          20m
    $ 
    ```
1. ICPコンソールからも確認してみます。ナビゲーション・メニューから[ワークロード]>[デプロイメント]を選択します。"mylibertyapp-deploy"のエントリーが表示され、デプロイメントの名前のハイパーリンクをクリックすることで、そのデプロイメントの詳細を確認できます。さらに、デプロイメントに含まれるポッドの詳細などのリンクもたどれます。
![DeploymentList](https://github.com/ICpTrial/ICPLab/blob/master/images/Lab4/Lab4_05_DeploymentList.png)

##　NodePortサービスの作成
1. NodePortサービスを作成する"mylibapp-nodeportservice.yaml"をテキスト・エディターで開き、内容を確認します。
    ```yaml:mylibapp-nodeportservice.yaml
    apiVersion: v1
    kind: Service
    metadata:
      name: mylibertyapp-nodeport
    spec:
      type: NodePort
      selector:
        app: mylibertyapp
      ports:
       - protocol: TCP
         port: 9080
         targetPort: 9080
         nodePort: 30180
    ```
    上記のサービス(NodePort)の定義ファイルでは、下記のような設定を記述しています。
    - 2行目の"kind: Service"で、サービスの定義であることを指定
    - 6行目の"type: NodePort"で、NodePortを指定。NodePortかkubernetesクラスター内の通信で使用するClusterIPかを指定できます。
    - 7,8行目の"selector: > app: mylibertyapp"で、割り振り先のデプロイメントを選択するラベルを指定
    - 12行目の"targetPort: 9080"で、割り振り先のポートを指定
    - 13行目の"nodePort: 30180"で、クラスター外部からアクセスすることができるポート番号を指定
1. `kubectl apply -f mylibapp-nodeportservice.yaml` コマンドを入力し、NodePortのサービスを作成します。
    ```
    $ kubectl apply -f mylibapp-nodeportservice.yaml
    service "mylibertyapp-nodeport" created
    $ 
    ```
1. 作成したサービスを確認します。`kubectl get services` または `kubectl get svc` コマンドを入力し、"mylibertyapp-nodeport"のエントリーが表示されることを確認します。
    ```
    $ kubectl get svc
    NAME                       TYPE       CLUSTER-IP   EXTERNAL-IP   PORT(S)          AGE
    liberty-default-helm-ibm   NodePort   10.0.0.26    <none>        9443:31114/TCP   9h
    mylibertyapp-nodeport      NodePort   10.0.0.17    <none>        9080:30180/TCP   1m
    $  
    ```
1. ICPコンソールからも、ナビゲーション・メニューから[ネットワーク・アクセス]>[サービス]を選択することで確認できます。
1. NodePortを作成することで、外部からアクセスできます。ブラウザーで、`http://(ICPのIP):30180/Sum/` と入力します。サンプル・アプリケーションにアクセスできることを確認します。
![NodePortAccess](https://github.com/ICpTrial/ICPLab/blob/master/images/Lab4/Lab4_06_NodePortAccess.png)

##　Ingressの作成
1. Ingressを作成する"mylibapp-ingress.yaml"をテキスト・エディターで開き、内容を確認します。
    ```mylibapp-ingress.yaml
    apiVersion: extensions/v1beta1
    kind: Ingress
    metadata:
      annotations:
        ingress.kubernetes.io/rewrite-target: /
      name: mylibetyapp-ingress
      namespace: handson
    spec:
      rules: 
      - host:
        http:
          paths:
          - path: /hoge
            backend:
              serviceName: mylibertyapp-nodeport
              servicePort: 9080
    ```
    上記のIngressの定義ファイルでは、下記のような設定を記述しています。
    - 2行目の"kind: Ingress"で、Ingressの定義であることを指定
    - 13行目の"- path: /hoge"で、Proxyノード宛の"/hoge"のリクエストを対象のサービス(NodePort)に転送するよう指定
    - 15,16行目のserviceName: mylibertyapp-nodeport"と"servicePort: 9080"で、転送先のサービス(NodePort)を指定
    - 5行目の"ingress.kubernetes.io/rewrite-target: /"で、ICPのProxyノードで内部的に構成されているnginxコントローラーで固有に利用できるrewrite-tagetの指定で、pathに指定した"/hoge"宛のリクエストを/に変更するよう指定
1. `kubectl apply -f mylibapp-ingress.yaml` コマンドを入力し、Ingressを作成します。
    ```
    $ kubectl apply -f mylibapp-ingress.yaml
    ingress "mylibetyapp-ingress" created
    $
    ```
1. 作成したサービスを確認します。`kubectl get ingresses` コマンドを入力し、"mylibertyapp-ingress"のエントリーが表示されることを確認します。
    ```
    $ kubectl get ingresses
    NAME                       HOSTS     ADDRESS          PORTS     AGE
    liberty-default-helm-ibm   *         161.202.248.83   80, 443   9h
    mylibetyapp-ingress        *         161.202.248.83   80        3m
    $
    ```
1. ICPコンソールからも、ナビゲーション・メニューから[ネットワーク・アクセス]>[サービス]で、「入口」タブを選択することで確認できます。
#1. Ingressを作成することで、Proxyノード経由の外部から"/hoge"のURLでアクセスできます。Proxy Nodeのデフォルトの構成である80番や443番のポートでアクセスできます。ブラウザーで、`http://(ICPのIP)/hoge/Sum/` と入力します。サンプル・アプリケーションにアクセスできることを確認します。

以上で、Lab4は終了です。引き続き、Lab4で、Microclimateをご紹介します。

