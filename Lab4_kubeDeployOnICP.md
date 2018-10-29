# Lab4. 独自のDockerイメージをICPにデプロイ

このLabでは、Lab2.で作成した独自のWebSphere LibertyのDockerイメージを、ICPにデプロイします。Helmチャートを使用してデプロイするのではなく、Kubernetesのオブジェクトを一つずつ作成していきます。

## 前提

この　Labでは、下記の準備を前提としています。
- PC環境からICP環境へのネットワークの接続
- PC環境からICPのプライベート・レジストリーへの認証の設定<br>
    [ICP Knowledge Center: Docker CLI の認証の構成](https://www.ibm.com/support/knowledgecenter/ja/SSBS6K_3.1.0/manage_images/configuring_docker_cli.html)
- PC上にkubectlコマンドのインストール<br>
    [ICP Knowledge Center: kubectl CLI からクラスターへのアクセス](https://www.ibm.com/support/knowledgecenter/ja/SSBS6K_3.1.0/manage_cluster/cfc_cli.html)
    ICPコンソールの[Command Line Tools]>[Cloud Private CLI]の[Install Kubectl CLI]の項目も参照ください

所用時間は、およそ60分です。

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
    PCのDockerレジストリーから、ICPのプライベート・レジストリーに、Dockerイメージを直接アップロード(docker push)するには、ICPのプライベート・レジストリーにdocker loginする必要があります。<br>
    `docker login <cluster_CA_domain>:8500` (デフォルトでは、`docker login cluster.local.icp:8500`) コマンドを入力します。事前に、認証設定の一部として、<cluster_CA_domain>のホスト名が、PC OSのhostsファイルで名前解決され、ICPのマスター・ノードのIPアドレスに解決されます。
    UsernameとPasswordの入力が求められますので、ICPの管理者ユーザーのユーザー名(デフォルト:admin)とパスワードを入力します。
    ```
    Yoshiki-no-MacBook-Air:Lab2 yoshiki$ docker login cluster.local.icp:8500
    Username: admin
    Password: 
    Login Succeeded
    Yoshiki-no-MacBook-Air:Lab2 yoshiki$ 
    ```
1. アップロードするイメージの確認
    `docker images` コマンドを入力し、Lab2. で作成した「mylibertyapp:1.0」のイメージがPCローカルのDockerレジストリーに存在することを確認します。
    ```
    yoshiki-no-air:Lab4 yoshiki$ docker images
    REPOSITORY                                   TAG                 IMAGE ID            CREATED             SIZE
    mylibertyapp                                 1.0                 4027ff6ba2c0        15 hours ago        508MB
    yoshiki-no-air:Lab4 yoshiki$ 
    ```
1. アップロードするイメージの名前の変更(追加)
    `docker tag <source_image> <target_image>` コマンド(<source_image>に対して、<target_image>の別名を付与します)で、アップロードするイメージに"<Dockerレジストリーのホスト>/<名前空間>/<イメージ名>:<tag名>"の別名をつけます。具体的には、'docker tag mylibertyapp:1.0 cluster.local.icp:8500/handson/mylibertyapp:1.0' コマンドを入力します。
    ```
    yoshiki-no-air:Lab4 yoshiki$ docker tag mylibertyapp:1.0 cluster.local.icp:8500/handson/mylibertyapp:1.0
    yoshiki-no-air:Lab4 yoshiki$ 
    ```
1. `docker images` コマンドを入力し、別名が付与されたイメージを確認します。
    ```
    yoshiki-no-air:Lab4 yoshiki$ docker images
    REPOSITORY                                   TAG                 IMAGE ID            CREATED             SIZE
    mylibertyapp                                 1.0                 4027ff6ba2c0        15 hours ago        508MB
    cluster.local.icp:8500/handson/mylibertyapp  1.0                 4027ff6ba2c0        15 hours ago        508MB
    yoshiki-no-air:Lab4 yoshiki$ 
    ```
    同じIMAGE IDのエントリーが2行表示され、ここで追加した名前のエントリーがあることを確認します。
1. イメージをアップロードします。
    `docker push <image_name>:<tag>`コマンドで、ICPのDockerプライベート・レジストリーにイメージをアップロードします。具体的には、`docker push cluster.local.icp:8500/handson/mylibertyapp:1.0` コマンドを入力します。
    ```
    Yoshiki-no-MacBook-Air:Lab2 yoshiki$ docker push cluster.local.icp:8500/handson/mylibertyapp:1.0
    The push refers to repository [cluster.local.icp:8500/handson/mylibertyapp]
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
    Yoshiki-no-MacBook-Air:Lab2 yoshiki$ 
    ```
1. アップロードされたイメージをICPコンソールから確認します。ICPコンソールにログインし、ナビゲーション・メニューから、[イメージ]を選択します。名前が"handson/mylibertyapp"のエントリーがあることを確認します。

1. コンソール画面の右下の「>_」の青丸のマークをクリックすると、このコンソール画面に表示している内容を取得するkubectlコマンドが表示されます。以降で、kubectlコマンドのコンテキスト(接続先)をICPに設定します。

## PC上のkubectlコマンドの接続先をICPに構成<br>
kubectlコマンドは、kubenetes標準のkubernetesクラスターを管理する標準のコマンドライン・ツールです。
1. 接続構成情報を取得します。ICPコンソールで、上端メニューの右端の人のアイコンをクリックし、[クライアントの構成]を選択します。
1. クライアント構成のポップアップ・ウィンドウが表示され、接続設定を行うために、コマンド・ラインに入力するコマンドが複数行にわたって表示されます。青枠の書類のマークのようなアイコン(Copy to clipboard)をクリックすることで、クリップボードに保管します。
1. 一旦テキスト・エディターに内容をペーストします。
    下記のような内容がペーストされます。
    ```
    kubectl config set-cluster cluster.local --server=https://(ICPのアドレス):8001 --insecure-skip-tls-verify=true
    kubectl config set-context cluster.local-context --cluster=cluster.local
    kubectl config set-credentials admin --token=eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdF9oYXNoIjoiZmNiaGVrc2d4MjNxbXFhN2o3OGYiLCJyZWFsbU5hbWUiOiJjdXN0b21SZWFsbSIsInVuaXF1ZVNlY3VyaXR5TmFtZSI6ImFkbWluIiwiaXNzIjoiaHR0cHM6Ly9pY3BjbHVzdGVyMDEuaWNwOjk0NDMvb2lkYy9lbmRwb2ludC9PUCIsImF1ZCI6IjVlZWQ0YTRmN2FlOGI0MmI1NWM2NzJiMzUwNjgyYWM0IiwiZXhwIjoxNTQwODI3MTY2LCJpYXQiOjE1NDA3OTgzNjYsInN1YiI6ImFkbWluIiwidGVhbVJvbGVNYXBwaW5ncyI6W119.hGAuoQ3mmjGYRY8Ez1lY6YhXodwvH4N9aEZPYBToaTzT6P4r2ylHDGWcfm-Ii5E-QI21i3mDKjgpp0TV5gDRP1NlUng9Uuz4U62gqEYLp9Jn4VV0mYXDBf86IWluDY23WNYhQ-vbfB-G8ldANTwM-HzHx6cyyaW_nNEE76zw_1Rvl1eKnJaOGqybNDuSqv8xkK-OmY0CjG2qktmg6LnefHqCAIQyQdyOlkJlx6nxacMmNAgfiiZ7AHPgS1CJYapQ9eIzadX4ql27X3pufslNSxW3wFNFzudEjV3gJtfNIAf6boXEuIrEZDmx9d99b5Qx6QuWVfP-oDidtZWxNr941Q
    kubectl config set-context cluster.local-context --user=admin --namespace=cert-manager
    kubectl config use-context cluster.local-context
    
    ```
1. 下から2行目のコマンドの中で、デフォルトの名前空間(namespace)を指定しています。コンソールからダウンロードされるコマンドは、名前空間が、「cert-manager」となっていますので、今回のハンズオンで使用する「handson」に修正します。修正後の下から2行目の内容は、下記のようになります。
    ```
    kubectl config set-context cluster.local-context --user=admin --namespace=handson
    ```
    修正後のコマンドの全体(5行)を選択し、再度、クリップボードにコピー([Ctrl]+c)します。
1. コマンドラインに貼り付けます。複数行のコマンドが連続的に実行されます。
    ```
    yoshiki-no-air:Lab4 yoshiki$ kubectl config set-cluster cluster.local --server=https://161.202.248.83:8001 --insecure-skip-tls-verify=true
    Cluster "cluster.local" set.
    yoshiki-no-air:Lab4 yoshiki$ kubectl config set-context cluster.local-context --cluster=cluster.local
    Context "cluster.local-context" modified.
    yoshiki-no-air:Lab4 yoshiki$ kubectl config set-credentials admin --token=eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdF9oYXNoIjoiZmNiaGVrc2d4MjNxbXFhN2o3OGYiLCJyZWFsbU5hbWUiOiJjdXN0b21SZWFsbSIsInVuaXF1ZVNlY3VyaXR5TmFtZSI6ImFkbWluIiwiaXNzIjoiaHR0cHM6Ly9pY3BjbHVzdGVyMDEuaWNwOjk0NDMvb2lkYy9lbmRwb2ludC9PUCIsImF1ZCI6IjVlZWQ0YTRmN2FlOGI0MmI1NWM2NzJiMzUwNjgyYWM0IiwiZXhwIjoxNTQwODI3MTY2LCJpYXQiOjE1NDA3OTgzNjYsInN1YiI6ImFkbWluIiwidGVhbVJvbGVNYXBwaW5ncyI6W119.hGAuoQ3mmjGYRY8Ez1lY6YhXodwvH4N9aEZPYBToaTzT6P4r2ylHDGWcfm-Ii5E-QI21i3mDKjgpp0TV5gDRP1NlUng9Uuz4U62gqEYLp9Jn4VV0mYXDBf86IWluDY23WNYhQ-vbfB-G8ldANTwM-HzHx6cyyaW_nNEE76zw_1Rvl1eKnJaOGqybNDuSqv8xkK-OmY0CjG2qktmg6LnefHqCAIQyQdyOlkJlx6nxacMmNAgfiiZ7AHPgS1CJYapQ9eIzadX4ql27X3pufslNSxW3wFNFzudEjV3gJtfNIAf6boXEuIrEZDmx9d99b5Qx6QuWVfP-oDidtZWxNr941Q
    User "admin" set.
    yoshiki-no-air:Lab4 yoshiki$ kubectl config set-context cluster.local-context --user=admin --namespace=handson
    Context "cluster.local-context" modified.
    yoshiki-no-air:Lab4 yoshiki$ kubectl config use-context cluster.local-context
    Switched to context "cluster.local-context".
    yoshiki-no-air:Lab4 yoshiki$ 
    ```
    最後の行の`kubectl config use-context cluster.local-context`が実行されていることを確認してください。実行されていない場合には、[Enter]キーを入力し、実行してください。
1. kubectlコマンドの接続先が、ICPで構成されていることを確認します。`kubectl get nodes` コマンドを入力し、NAME欄に表示されるIPアドレスが、対象のICPのサーバーとなっていることを確認します。
    ```
    yoshiki-no-air:Lab4 yoshiki$ kubectl get nodes
    NAME           STATUS    ROLES                                    AGE       VERSION
    10.129.86.68   Ready     etcd,management,master,proxy,va,worker   20d       v1.11.1+icp-ee
    yoshiki-no-air:Lab4 yoshiki$ 
    ```
1. ICPのプライベート・レジストリーに保管されている"mylibertyapp"のイメージを、kubectlコマンドで確認してみます。`kubectl get images` コマンドを入力します。
    ```
    yoshiki-no-air:Lab4 yoshiki$ kubectl get images
    NAME           AGE
    mylibertyapp   55m
    yoshiki-no-air:Lab4 yoshiki$ 
    ```
    mylibertyappのイメージの存在が確認できます。今回、このkubectlは、"handson"の名前空間を対象にしてオブジェクトを表示しています。`--all-namespaces` オプションを付与することで、すべての名前空間のオブジェクトを表示することもできます。
    ```
    yoshiki-no-air:Lab4 yoshiki$ kubectl get images --all-namespaces
    NAMESPACE   NAME                                     AGE
    handson     mylibertyapp                             58m
    ibmcom      alertmanager-amd64                       20d
    ibmcom      calico-cni-amd64                         20d
    ibmcom      calico-kube-controllers-amd64            20d
    (以下略)
    ```




