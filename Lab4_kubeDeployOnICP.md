# Lab4. 独自のDockerイメージをICPにデプロイ

このLabでは、Lab2.で作成した独自のWebSphere LibertyのDockerイメージを、ICPにデプロイします。Helmチャートを使用してデプロイするのではなく、Kubernetesのオブジェクトを一つずつ作成していきます。

## 前提

この　Labでは、下記の準備を前提としています。
- docker環境からICP環境へのネットワークの接続

所用時間は、およそ40分です。
    
## LibertyイメージをICPのプライベート・レジストリーに ファイル転送でのアップロード
ここでは、改めて開発環境と本番環境など、直接ネットワークが接続できない環境でイメージを移動させる方法で、イメージをICP環境に登録します。
   1. Lab2で利用した docker環境にSSH でログインします 
   1. アップロードするイメージの確認<br>
            `docker images` コマンドを入力し、Lab2. で作成した「mylibertyapp:1.0」のイメージがPCローカルのDockerレジストリーに存在することを確認します。
            ```
            $ docker images |  grep myliberty
            REPOSITORY                                   TAG                 IMAGE ID            CREATED             SIZE
            mylibertyapp                                 1.0                 4027ff6ba2c0        15 hours ago        508MB
            $ 
            ```        
    1. アップロードするイメージの名前の変更(追加)<br>
            `docker tag <source_image> <target_image>` コマンド(<source_image>に対して、<target_image>の別名を付与します)で、アップロードするイメージに"<Dockerレジストリーのホスト>/<名前空間>/<イメージ名>:<tag名>"の別名をつけます。これにより、名前空間ごとにアクセス制御をしてイメージを登録することができます。<br>
            具体的には、'docker tag mylibertyapp:1.0 mycluster.icp:8500/handson/mylibertyapp:1.0' コマンドを入力します。

            ```
            $ docker tag mylibertyapp:1.0 mycluster.icp:8500/handson/mylibertyapp:1.0
            $ 
            ```
    1. `docker images` コマンドを入力し、別名が付与されたイメージを確認します。<br>
        ```
        $ docker images | grep myliberty
        REPOSITORY                                   TAG                 IMAGE ID            CREATED             SIZE
        mylibertyapp                                 1.0                 4027ff6ba2c0        15 hours ago        508MB
        mycluster.icp:8500/handson/mylibertyapp  1.0                 4027ff6ba2c0        15 hours ago        508MB
        $ 
        ```
            同じIMAGE IDのエントリーが2行表示され、ここで追加した名前のエントリーがあることを確認します。
            
   1. docker save コマンドで dockerイメージを save し、tarに固めます。
        ```
        docker save <imagename> -o <output>.tar
        ```
        具体的には以下のようになります。
        ```
        docker save mycluster.icp:8500/handson/mylibertyapp:1.0 -o mylibertyapp.tar
        ```
   1. この イメージを ICP側にSCPで転送します。
        ```
        scp ./mylibetyapp.tar root@mycluster.icp:/work
        ```
   1. ICP側にログインして、/workディレクトリに移動します
        ```
        cd /work
        ```
   1. docker load コマンドで、dockerイメージを展開します。
        ```
        docker load -i mylibertyapp.tar
        ```
   1. docker images で 確認します。
        ```
        docker images  | grep myliberty
        mycluster.icp:8500/handson/mylibertyapp                            1.0                            dea29e33a7cf        2 hours ago         531MB
        ```
        
   1. 改めて、ICPのプライベート・レジストリにログインして、イメージをPUSHします。
        ```
        root@icp11:/work# docker login mycluster.icp:8500
        Username: admin
        Password:
        Login Succeeded
        
        root@icp11:/work# docker push mycluster.icp:8500/handson/mylibertyapp
        The push refers to repository [mycluster.icp:8500/handson/mylibertyapp]
        8182b41e09da: Pushed
        76ef98385b09: Pushed
        db87010d02e5: Pushed
        321ce75a5fca: Pushed
        bc5efcf2cde7: Pushed
        2bc664e4ef1d: Pushed
        c2ed64fc1c64: Pushed
        4e627fb0ad12: Pushed
        6ea9c65246b6: Pushed
        be1f0d1bf508: Pushed
        7682af823d56: Pushed
        315372866a66: Pushed
        e69837263007: Pushed
        b41f85827054: Pushed
        428c1ba11354: Pushed
        b097f5edab7b: Pushed
        27712caf4371: Pushed
        8241afc74c6f: Pushed
        1.0: digest: sha256:a57817c674552e53f6cd4c1e0670a2238a454abee0d028365934b0c43a9ca77e size: 4089
        ```    
1. アップロードされたイメージをICPコンソールから確認します。ICPコンソールにログインし、ナビゲーション・メニューから、[イメージ]を選択します。名前が"handson/mylibertyapp"のエントリーがあることを確認します。
![Image](https://github.com/ICpTrial/ICPLab/blob/master/images/Lab4/Lab4_01_Image.png)


## [参考] docker環境からICPのdockerプライベート・レジストリーへの直接PUSH
ここはスキップすることができます。さっと目を通してください。

1. docker環境から ICPの dockerプライベート・レジストリーへの接続・認証設定<br>
docker環境のDockerレジストリーから、ICPのdocker プライベート・レジストリーに、Dockerイメージを直接アップロード(docker push)することも可能です。これには、docker側から ICPのプライベート・レジストリーにdocker loginする必要があります。

    [ICP Knowledge Center: Docker CLI の認証の構成](https://www.ibm.com/support/knowledgecenter/ja/SSBS6K_3.1.0/manage_images/configuring_docker_cli.html)に従って、設定をしていきます。

   1. Lab2で利用した docker環境にSSH でログインします。
   1. rootユーザーで /etc/hosts を開き、以下の一行を追加します。ここでは、<cluster_CA_domain>は `mycluster.icp` です
        ```
        <icp_master_ip>     <cluster_CA_domain>
        ```
   1. docker環境から、ICPのプライベート・レジストリーにdockerログインしてみます。
        ```
        docker login mycluster.icp:8500
        Username: admin
        Password:
        Error response from daemon: Get https://mycluster.icp:8500/v2/: x509: certificate signed by unknown authority
        ```
        エラーが出てアクセスできませんので、これを解消していきます。

   1. docker環境側に Docker レジストリー証明書を保管するディレクトリーを作成します
        ```
        mkdir -p /etc/docker/certs.d/mycluster.icp:8500
        ```
   1. ICP環境のdockerレジストリの証明書を docker環境側に 取得してきます。
        ```
        scp root@<cluster_CA_domain>:/etc/docker/certs.d/<cluster_CA_domain>\:8500/ca.crt ~/.docker/certs.d/<cluster_CA_domain>\:8500/
        ```

        今回の環境では以下のようになります。
        ```
        scp root@mycluster.icp:/etc/docker/certs.d/mycluster.icp:8500/ca.crt /etc/docker/certs.d/mycluster.icp\:8500/
        ```
   1. 改めて ICP環境のプライベート・レジストリにログインしてみます。
        ```
        root@docker11:~# docker login mycluster.icp:8500
        Username: admin
        Password:
        Login Succeeded
        ```
   (参照)
   [ICP KnowledgeCenter: イメージのプッシュおよびプル](https://www.ibm.com/support/knowledgecenter/ja/SSBS6K_3.1.0/manage_images/using_docker_cli.html)

    
1. 実際にイメージをPUSHしていきます。<br>
   1. アップロードするイメージの確認<br>
            `docker images` コマンドを入力し、Lab2. で作成した「mylibertyapp:1.0」のイメージがPCローカルのDockerレジストリーに存在することを確認します。
            ```
            $ docker images |  grep myliberty
            REPOSITORY                                   TAG                 IMAGE ID            CREATED             SIZE
            mylibertyapp                                 1.0                 4027ff6ba2c0        15 hours ago        508MB
            $ 
            ```        
    1. アップロードするイメージの名前の変更(追加)<br>
            `docker tag <source_image> <target_image>` コマンド(<source_image>に対して、<target_image>の別名を付与します)で、アップロードするイメージに"<Dockerレジストリーのホスト>/<名前空間>/<イメージ名>:<tag名>"の別名をつけます。これにより、名前空間ごとにアクセス制御をしてイメージを登録することができます。<br>
            具体的には、'docker tag mylibertyapp:1.0 mycluster.icp:8500/handson/mylibertyapp:1.0' コマンドを入力します。

            ```
            $ docker tag mylibertyapp:1.0 mycluster.icp:8500/handson/mylibertyapp:1.0
            $ 
            ```
    1. `docker images` コマンドを入力し、別名が付与されたイメージを確認します。<br>
        ```
        $ docker images | grep myliberty
        REPOSITORY                                   TAG                 IMAGE ID            CREATED             SIZE
        mylibertyapp                                 1.0                 4027ff6ba2c0        15 hours ago        508MB
        mycluster.icp:8500/handson/mylibertyapp  1.0                 4027ff6ba2c0        15 hours ago        508MB
        $ 
        ```
            同じIMAGE IDのエントリーが2行表示され、ここで追加した名前のエントリーがあることを確認します。

    1. イメージをアップロードします。<br>
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

## ICP環境への CLIでのログイン

1. cloudctl コマンドを利用して、CLIで ICP環境にログインします。デフォルトのネームスペースの選択の際には handson を選択してください。
    ```
    root@icp11:/work# cloudctl login -a https://mycluster.icp:8443 --skip-ssl-validation

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
    5. istio-system
    6. kube-public
    7. kube-system
    8. platform
    9. services
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

1. kubectlコマンドが利用できることを確認します。`kubectl get nodes` コマンドを入力し、NAME欄に表示されるIPアドレスが、対象のICPのサーバーとなっていることを確認します。
    ```
    $ kubectl get nodes
    NAME           STATUS    ROLES                                    AGE       VERSION
    10.129.86.68   Ready     etcd,management,master,proxy,va,worker   20d       v1.11.1+icp-ee
    $ 
    ```
## kubectl コマンドを利用して、実際に ICP環境にデプロイしていきます。
    
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


1. このLabの作業ディレクトリー (/work/lab4) に移動します。このディレクトリーには、下記のファイルが事前に準備されています。
    - mylibapp-deployment.yaml : デプロイメント作成時の定義ファイル
    - mylibapp-nodeportservice.yaml : サービス(NodePort)作成時の定義ファイル
    - mylibapp-ingress.yaml : Ingress作成時の定義ファイル
    
1. kubectlコマンドで、kubernetesのオブジェクトを作成する場合、オブジェクトの定義情報を、yamlまたはjsonファイル形式で記述し、`kubectl apply -f <file_name>` コマンドで適用します。オブジェクトの新規作成も、オブジェクトの更新も、同じコマンドで実行できます。

1. デプロイメントを作成するためのyamlファイルを、Lab4ディレクトリーに準備しています。"mylibapp-deployment.yaml"をcat で開き、内容を確認します。
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
    $ kubectl get pods 
    NAME                                        READY     STATUS    RESTARTS   AGE
    liberty-default-helm-ibm-6f6fc5fbfd-4khv8   1/1       Running   0          8h
    mylibertyapp-deploy-648c4645f9-dj5nv        1/1       Running   0          20m
    $ 
    ```
1. ICPコンソールからも確認してみます。ナビゲーション・メニューから[ワークロード]>[デプロイメント]を選択します。"mylibertyapp-deploy"のエントリーが表示され、デプロイメントの名前のハイパーリンクをクリックすることで、そのデプロイメントの詳細を確認できます。さらに、デプロイメントに含まれるポッドの詳細などのリンクもたどれます。
![DeploymentList](https://github.com/ICpTrial/ICPLab/blob/master/images/Lab4/Lab4_05_DeploymentList.png)

##　NodePortサービスの作成
1. サービスを公開するための NodePortサービスを作成する"mylibapp-nodeportservice.yaml"をcat で開き、内容を確認します。
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
    - 13行目の"nodePort: 30180"で、クラスター外部からアクセスすることができるポート番号を指定。ここでは固定で指定しています。指定しない場合はダイナミックに割り振られます。
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
1. Ingressを作成する"mylibapp-ingress.yaml"をcat で開き、内容を確認します。
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
          - path: /handson
            backend:
              serviceName: mylibertyapp-nodeport
              servicePort: 9080
    ```
    上記のIngressの定義ファイルでは、下記のような設定を記述しています。
    - 2行目の"kind: Ingress"で、Ingressの定義であることを指定
    - 13行目の"- path: /handson"で、Proxyノード宛の"/handson"のリクエストを対象のサービス(NodePort)に転送するよう指定
    - 15,16行目のserviceName: mylibertyapp-nodeport"と"servicePort: 9080"で、転送先のサービス(NodePort)を指定
    - 5行目の"ingress.kubernetes.io/rewrite-target: / "で、ICPのProxyノードで内部的に構成されているnginxコントローラーで固有に利用できるrewrite-tagetの指定で、pathに指定した"/handson/"宛のリクエストを バックエンドのサービスの / にマップ
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
1. さらに詳細に確認するため `kubectl describe ingresses ylibetyapp-ingress` コマンドを実行します。
    ```
    $ kubectl describe ingresses mylibetyapp-ingress
    Name:             mylibetyapp-ingress
    Namespace:        handson
    Address:          161.202.248.83
    Default backend:  default-http-backend:80 (<none>)
    Rules:
      Host  Path  Backends
      ----  ----  --------
      *
            /handson   mylibertyapp-nodeport:9080 (<none>)
    Annotations:
      ingress.kubernetes.io/rewrite-target:              /
      kubectl.kubernetes.io/last-applied-configuration:  {"apiVersion":"extensions/v1beta1","kind":"Ingress","metadata":{"annotations":{"ingress.kubernetes.io/rewrite-target":"/"},"name":"mylibetyapp-ingress","namespace":"handson"},"spec":{"rules":[{"host":null,"http":{"paths":[{"backend":{"serviceName":"mylibertyapp-nodeport","servicePort":9080},"path":"/hoge"}]}}]}}

    Events:
      Type    Reason  Age   From                      Message
      ----    ------  ----  ----                      -------
      Normal  CREATE  1m    nginx-ingress-controller  Ingress handson/mylibetyapp-ingress
      Normal  UPDATE  43s   nginx-ingress-controller  Ingress handson/mylibetyapp-ingress
    ```
1. ICPコンソールからも、ナビゲーション・メニューから[ネットワーク・アクセス]>[サービス]で、「入口」タブを選択することで確認できます。
1. Ingressを作成することで、Proxyノード経由の外部から"/handson"のURLでアクセスできます。Proxy Nodeのデフォルトの構成である80番や443番のポートでアクセスできます。ブラウザーで、`http://(ICPのIP)/handson/Sum/` と入力します。サンプル・アプリケーションにアクセスできることを確認します。

1. ingressの構成を編集して、適用してみます。Ingressの rewrite ターゲットの指定を / から /Sum に編集します。
    ```
    apiVersion: extensions/v1beta1
    kind: Ingress
    metadata:
      annotations:
        ingress.kubernetes.io/rewrite-target: /Sum　　## ここを編集
      name: mylibetyapp-ingress
      namespace: handson
    spec:
      rules:
      - host:
        http:
          paths:
          - path: /handson
            backend:
              serviceName: mylibertyapp-nodeport
              servicePort: 9080
    ```
1. あらためて kubectl apply コマンドで 適用します。同じ定義を変更してapplyしているので定義が更新されます。
    ```
    root@icp11:/work/lab4# kubectl apply -f mylibapp-ingress.yaml
    ingress.extensions/mylibetyapp-ingress configured
    ```
1. `kubectl describe ingresses ylibetyapp-ingress` コマンドを実行して、定義が更新されていることを確認します。    
    ```
    kubectl describe ingresses mylibetyapp-ingress
    Name:             mylibetyapp-ingress
    Namespace:        handson
    Address:          165.192.65.171
    Default backend:  default-http-backend:80 (<none>)
    Rules:
      Host  Path  Backends
      ----  ----  --------
      *
            /handson   mylibertyapp-nodeport:9080 (<none>)
    Annotations:
      ingress.kubernetes.io/rewrite-target:              /Sum
      kubectl.kubernetes.io/last-applied-configuration:  {"apiVersion":"extensions/v1beta1","kind":"Ingress","metadata":{"annotations":{"ingress.kubernetes.io/rewrite-target":"/Sum"},"name":"mylibetyapp-ingress","namespace":"handson"},"spec":{"rules":[{"host":null,"http":{"paths":[{"backend":{"serviceName":"mylibertyapp-nodeport","servicePort":9080},"path":"/handson"}]}}]}}

        Events:
          Type    Reason  Age              From                      Message
          ----    ------  ----             ----                      -------
          Normal  CREATE  9m               nginx-ingress-controller  Ingress handson/mylibetyapp-ingress
          Normal  UPDATE  1m (x3 over 8m)  nginx-ingress-controller  Ingress handson/mylibetyapp-ingress    
        ```
1. ブラウザでアクセスして確認します。
    今度は /handson/宛のリクエストが バックエンドの /Sum にマップされているので、`http://(ICPのIP)/handson/` でアクセスできます。
    さきほどまでの `http://(ICPのIP)/handson/Sum`ではファイルがないため、エラーとなることを確認してください。
    
以上で、Lab4は終了です。
