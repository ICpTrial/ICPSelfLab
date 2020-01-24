# Lab6. 独自のDockerイメージをICPにデプロイ

このLabでは、Lab3で作成した独自のWebSphere LibertyのDockerイメージを、ICPにデプロイします。Helmチャートを使用してデプロイするのではなく、Kubernetesのオブジェクトを一つずつ作成していきます。

## 前提

この　Labでは、下記の準備を前提としています。
- Lab3が終了していること

所用時間は、およそ40分です。

## ハンズオン環境の事前準備

1. ハンズオン環境の作業ディレクトリを作成し、関連ファイルをアップロードしておきます。  
    
    1. 作業ディレクトリを作成します。
        ```
        # mkdir -p /work/lab6
        ```
    1. ハンズオン・マテリアル lab6material.tar は[こちら](https://github.com/ICpTrial/ICPSelfLab/raw/master/lab6material.tar)にありますので、ダウンロードしてください。
    1. 作成した作業ディレクトリにアップロードします。
        ```
        (作業PCで実施）
        $ scp lab6material.tar root@<machine_ip>:/work/lab6
        ```
    1. アップロードしたファイルを解凍します。
        ```
        # cd /work/lab6
        # tar -xvf lab6material.tar
        ```
    
## ICPのDockerプライベート・レジストリーに イメージをPUSHします。

[ICP KnowledgeCenter: イメージのプッシュおよびプル](https://www.ibm.com/support/knowledgecenter/ja/SSBS6K_3.1.0/manage_images/using_docker_cli.html) に従い、
IBM Cloud Private内のプライベートDockerレジストリに、コンテナ・イメージをPUSHしていきます。

   1. アップロードするイメージの確認
        `docker images` コマンドを入力し、Lab3. で作成した「mylibertyapp:1.0」のイメージがPCローカルのDockerレジストリーに存在することを確認します。
        ```
        # docker images |  grep myliberty
        REPOSITORY                                   TAG                 IMAGE ID            CREATED             SIZE
        mylibertyapp                                 1.0                 4027ff6ba2c0        15 hours ago        508MB
        ```        
   1. アップロードするイメージの名前の変更(追加)
        `docker tag <source_image> <target_image>` コマンド(<source_image>に対して、<target_image>の別名を付与します)で、アップロードするイメージに"<Dockerレジストリーのホスト>/<名前空間>/<イメージ名>:<tag名>"の別名をつけます。これにより、名前空間ごとにアクセス制御をしてイメージを登録することができます。<br>
        具体的には、'docker tag mylibertyapp:1.0 mycluster.icp:8500/handson/mylibertyapp:1.0' コマンドを入力します。

        ```
        # docker tag mylibertyapp:1.0 mycluster.icp:8500/handson/mylibertyapp:1.0 
        ```
   1. `docker images` コマンドを入力し、別名が付与されたイメージを確認します。
        ```
        # docker images | grep myliberty
        REPOSITORY                                   TAG                 IMAGE ID            CREATED             SIZE
        mylibertyapp                                 1.0                 4027ff6ba2c0        15 hours ago        508MB
        mycluster.icp:8500/handson/mylibertyapp      1.0                 4027ff6ba2c0        15 hours ago        508MB 
        ```
        同じIMAGE IDのエントリーが2行表示され、ここで追加した名前のエントリーがあることを確認します。


   1. ICP環境の dockerプライベート・レジストリにログインします。
        ```
        # docker login mycluster.icp:8500
        Username: admin
        Password:
        Login Succeeded
        ```

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
        ```
   1. アップロードされたイメージをICPコンソールから確認します。ICPコンソールにログインし、ナビゲーション・メニューから、[コンテナー・イメージ]を選択します。名前が"handson/mylibertyapp"のエントリーがあることを確認します。
![Image](https://github.com/ICpTrial/ICPLab/blob/master/images/Lab4/Lab4_01_Image.png)

   1. 同様に、mylibertyapp:2.0 のイメージも ICPのDockerプライベート・レジストリーにアップロードしておきましょう。
        1. 以下のコマンドで、エイリアスを設定します
            ```
            docker tag mylibertyapp:2.0 mycluster.icp:8500/handson/mylibertyapp:2.0 
            ```
        1. イメージを push します
            ```
            docker push mycluster.icp:8500/handson/mylibertyapp:2.0
            ```
            

## [参考] LibertyイメージをICPのプライベート・レジストリーに ファイル転送でのアップロード
ここでは、開発環境と本番環境など、直接ネットワークが接続できない環境でイメージを移動させる方法を記載します。参考にしてください。
   1. docker tag コマンドで dockerイメージにタグをつけます
   
      ```
      # docker tag mylibertyapp:1.0 mycluster.icp:8500/handson/mylibertyapp:1.0
      ```
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
        scp ./mylibertyapp.tar root@mycluster.icp:/work
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

## ICP環境への CLIでのログイン

1. cloudctl コマンドを利用して、CLIで ICP環境にログインします。デフォルトのネームスペースの選択の際には `handson` を選択してください。
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
    "mylibertyapp"のイメージの存在が確認できます。今回、このkubectlは、`handson`の名前空間を対象にしてオブジェクトを表示しています。`--all-namespaces` オプションを付与することで、すべての名前空間のオブジェクトを表示することもできます。
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

1. このLabの作業ディレクトリー (/work/lab6) に移動します。このディレクトリーには、先の手順で以下のファイルを配置しました。
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
            image: mycluster.icp:8500/handson/mylibertyapp:1.0
            ports:
            - containerPort: 9080
    ```
    上記のデプロイメントの定義ファイルでは、下記のような設定を記述しています。
    - 2行目の"kind: Deployment"で、デプロイメントの定義であることを指定
    - 6行目の"replicas: 1"で、ポッドの複製の数を指定
    - 17行目の"image: muclsuter.icp:8500/handson/mylibertyapp:1.0"で、コンテナーのイメージを指定
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

## NodePortサービスの作成

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

## Ingressの作成

1. Ingressを作成する"mylibapp-ingress.yaml"をcat で開き、内容を確認します。
    ```
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
1. さらに詳細に確認するため `kubectl describe ingresses mylibetyapp-ingress` コマンドを実行します。
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


## Kubernetes 基本機能の確認１： スケーラビリティ

1. Kubernetesにおいては、ポリシー・ベースで柔軟にアプリケーションをスケールさせることが可能です。現在は、１インスタンス動いている mylibertyapp のデプロイメントをスケールアウトしてみます。

    1. 以下のコマンドで、現在の環境のデプロイメントの状況を確認します。
        ```
        # kubectl get deployments/mylibertyapp-deploy
        NAME                  DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
        mylibertyapp-deploy   1         1         1            1           18h
        kubectl get pods
        
        # kubectl get pods
        NAME                                        READY   STATUS    RESTARTS   AGE
        liberty-default-helm-ibm-595757b554-tjl4f   1/1     Running   0          19h
        mylibertyapp-deploy-74f4dc5f7d-8s2mp        1/1     Running   0          18h
        ```
    1. 先ほど、デプロイメントの作成に使用したファイル `mylibapp-deployment.yaml` のインスタンス数のポリシーを変更して適用します。<br>あるべき姿をポリシーとして定義し適用することで、そのポリシーに沿うように Kubernetes が配置を行います。<br>mylibapp-deployment.yaml に定義されている spec.replicas のインスタンス数を 1 -> 3　に変更します。
        ```
            apiVersion: apps/v1
                kind: Deployment
                metadata:
                  name: mylibertyapp-deploy
                spec:
                  replicas: 3               ##ここを編集
                  selector:
                    matchLabels:
                      app: mylibertyapp
            （後略）
        ```
    1. 以下のコマンドで編集されたポリシーを適用します。
        ```
        kubectl apply -f mylibapp-deployment.yaml
        ```
    1. 先ほどと同じコマンドで、状況を確認します。AGEの欄を確認すると、いつそのインスタンスが起動したかがわかります。
        ```
        # kubectl get deployments/mylibertyapp-deploy       
        NAME                  DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
        mylibertyapp-deploy   3         3         3            3           18h
        
        # kubectl get pods
        NAME                                        READY   STATUS    RESTARTS   AGE
        liberty-default-helm-ibm-595757b554-tjl4f   1/1     Running   0          19h
        mylibertyapp-deploy-74f4dc5f7d-28xbz        1/1     Running   0          91s
        mylibertyapp-deploy-74f4dc5f7d-8s2mp        1/1     Running   0          18h
        mylibertyapp-deploy-74f4dc5f7d-ksr98        1/1     Running   0          91s
        ```
 
## Kubernetes 基本機能の確認２： リカバリー
    
1. 障害が発生するなどし、ポリシーが満たされない状況になると、Kubernetesがポリシーを満たすように自動的にアクションが取られます。ここでは、先ほどのmylibertyapp の Podを１つ削除してみます。

    1. 先ほど `kubectl get pods` で表示された３つの Pod インスタンスのうち、任意の一つを選んで削除してみます。
        ```
        # kubectl delete pods <podインスタンス名>
        ```
        上の例ですと `kubectl delete pods mylibertyapp-deploy-74f4dc5f7d-ksr98` で一番下のインスタンスを削除します。
        
    1.  再び ポッドの状況を確認してみてください。すぐに３つにリカバリーされているかもしれませんが、先ほどとは異なるインスタンスが稼働していることがわかるはずです。
        ```
        # kubectl get pods
        NAME                                        READY   STATUS    RESTARTS   AGE
        liberty-default-helm-ibm-595757b554-tjl4f   1/1     Running   0          19h
        mylibertyapp-deploy-74f4dc5f7d-28xbz        1/1     Running   0          14m
        mylibertyapp-deploy-74f4dc5f7d-8s2mp        1/1     Running   0          19h
        mylibertyapp-deploy-74f4dc5f7d-lhbnk        1/1     Running   0          13s
        ```
        
 ## Kubernetes 基本機能の確認３： ロールアウト・アップデート
 
 1. Kubernetes の標準機能として、ロールアウト・アップデート機能を持っています。この確認をしてみます。
    
    1. 以下の コマンドで、現在のデプロイメントの設定を確認します。中断にある StrategyTYpe と RollingUpdateStrategy を確認ください。
        ```
        # kubectl describe deployment mylibertyapp-deploy
        Name:                   mylibertyapp-deploy
        Namespace:              handson
        CreationTimestamp:      Wed, 08 May 2019 09:13:28 +0000
        Labels:                 <none>
        Annotations:            deployment.kubernetes.io/revision: 1
                                kubectl.kubernetes.io/last-applied-configuration:
                                  {"apiVersion":"apps/v1","kind":"Deployment","metadata":{"annotations":{},"name":"mylibertyapp-deploy","namespace":"handson"},"spec":{"repl...
        Selector:               app=mylibertyapp
        Replicas:               3 desired | 3 updated | 3 total | 3 available | 0 unavailable
        StrategyType:           RollingUpdate
        MinReadySeconds:        0
        RollingUpdateStrategy:  25% max unavailable, 25% max surge
        Pod Template:
          Labels:  app=mylibertyapp
          Containers:
           myliberty-container:
            Image:        mycluster.icp:8500/handson/mylibertyapp:1.0
            Port:         9080/TCP
            Host Port:    0/TCP
            Environment:  <none>
            Mounts:       <none>
          Volumes:        <none>
        Conditions:
          Type           Status  Reason
          ----           ------  ------
          Progressing    True    NewReplicaSetAvailable
          Available      True    MinimumReplicasAvailable
        OldReplicaSets:  <none>
        NewReplicaSet:   mylibertyapp-deploy-74f4dc5f7d (3/3 replicas created)
        Events:
          Type    Reason             Age                From                   Message
          ----    ------             ----               ----                   -------
          Normal  ScalingReplicaSet  56m                deployment-controller  Scaled down replica set mylibertyapp-deploy-74f4dc5f7d to 1
          Normal  ScalingReplicaSet  18m (x2 over 18h)  deployment-controller  Scaled up replica set mylibertyapp-deploy-74f4dc5f7d to 3
            mylibertyapp-deploy
        ```
    
    1. 現在、`mylibertyapp:1.0` のイメージが利用されていますので、このイメージを `mylibertyapp:2.0` に更新します。このコマンドは、Deployment定義の中のイメージのバージョンを変更しています。
    
        ```
        # kubectl set image  deployments/mylibertyapp-deploy myliberty-container=mycluster.icp:8500/handson/mylibertyapp:2.0
        ```

        直後に 以下のコマンドで、ステータスを確認してみてください。
        ```
        # kubectl rollout status deployment/mylibertyapp-deploy
        ```
     
        ```
        # kubectl rollout status deployment/mylibertyapp-deploy
        Waiting for deployment "mylibertyapp-deploy" rollout to finish: 1 out of 3 new replicas have been updated...
        Waiting for deployment "mylibertyapp-deploy" rollout to finish: 1 out of 3 new replicas have been updated...
        Waiting for deployment "mylibertyapp-deploy" rollout to finish: 1 out of 3 new replicas have been updated...
        Waiting for deployment "mylibertyapp-deploy" rollout to finish: 2 out of 3 new replicas have been updated...
        Waiting for deployment "mylibertyapp-deploy" rollout to finish: 2 out of 3 new replicas have been updated...
        Waiting for deployment "mylibertyapp-deploy" rollout to finish: 2 out of 3 new replicas have been updated...
        Waiting for deployment "mylibertyapp-deploy" rollout to finish: 1 old replicas are pending termination...
        Waiting for deployment "mylibertyapp-deploy" rollout to finish: 1 old replicas are pending termination...
        deployment "mylibertyapp-deploy" successfully rolled out
        ```
        
    1. kubetctl get pods コマンドで状況を確認します。 
        ```
        # kubectl get pods
        NAME                                        READY   STATUS        RESTARTS   AGE
        liberty-default-helm-ibm-595757b554-tjl4f   1/1     Running       0          19h
        mylibertyapp-deploy-6dbb8b77bf-d6qkc        1/1     Running       0          16s
        mylibertyapp-deploy-6dbb8b77bf-v5n7n        1/1     Running       0          14s
        mylibertyapp-deploy-6dbb8b77bf-vkrfb        1/1     Running       0          18s
        mylibertyapp-deploy-74f4dc5f7d-8s2mp        0/1     Terminating   0          19h
        ```
        
    1. 実際に ブラウザーで、`http://(ICPのIP)/handson/Sum/` にアクセスして、アプリケーションが更新されていることを確認します。
    
    
##  Kubernetes 基本機能の確認４： ロールバック

1. 更新に問題があった場合に、更新を元に戻すための機能も Kubernetesとして提供しています。元の環境に手を入れているわけではないので、すぐに戻すことが可能です。
    1. 以下のコマンドで ロールアウト の履歴を確認します。まだ１度しか更新していないので、履歴は２です。
        ```
        # kubectl rollout history deployments/mylibertyapp-deploy
        deployment.extensions/mylibertyapp-deploy
        REVISION  CHANGE-CAUSE
        1         <none>
        2         <none>
        ```   
    1. 以下のコマンドで、直前の更新を取り消します。
        ```
        # kubectl rollout undo deployment/mylibertyapp-deploy
        ```
    1. 実際に ブラウザーで、`http://(ICPのIP)/handson/Sum/` にアクセスして、アプリケーションの更新が元に戻されていることを確認します。
   
        
以上で、Lab6は終了です。


