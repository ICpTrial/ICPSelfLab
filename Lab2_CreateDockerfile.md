# Lab2. 独自のDockerイメージの作成

このLabでは、WebSphere LibertyのDockerイメージを元に、独自のアプリをデプロイしたDockerイメージを作成します。

## 前提

この　Labでは、下記の準備を前提としています。
- Docker for WindowsまたはDocker for Macの導入
- インターネットに接続できる環境

所用時間は、およそ30分です。

## ハンズオン環境の確認

1. コマンド・プロンプトを起動します。
1. このLabの作業ディレクトリー (C:¥Handson¥Lab2) に移動します。このディレクトリーには、下記のファイルが事前に準備されています。
    - Sum.war : Libertyのサンプル・アプリケーション
    - server.xml : サンプル・アプリケーション用のLibertyの構成ファイル
    - Dockerfile : サンプル・アプリケーションがデプロイされたDockerイメージをビルドするためのDockerfile

## LibertyイメージのPull
1. `docker pull websphere-liberty:webProfile8` コマンドを入力し、WebSphere LibertyのwebProfile8のイメージをダウンロードします。<br>
    ここでは、`:webProfile8`のタグを指定しています。LibertyのDockerイメージは、javaee8やkernelなど、複数のタグ付けされたイメージが公開されています。<br>
    [docker store: IBM WebSphere Application Server Liberty](https://store.docker.com/images/websphere-liberty)
    ```
    Yoshiki-no-MacBook-Air:Lab1 yoshiki$ docker pull websphere-liberty:webProfile8
    webProfile8: Pulling from library/websphere-liberty
    18d680d61657: Pull complete 
    0addb6fece63: Pull complete 
    78e58219b215: Pull complete 
    eb6959a66df2: Pull complete 
    d28276d78514: Pull complete 
    f4b7f9cac3ff: Pull complete 
    f19e501afcfb: Pull complete 
    601831a5e775: Pull complete 
    c74aac9cae92: Pull complete 
    d75dab0dabf9: Pull complete 
    43743ccf0758: Pull complete 
    a9b805cd2f15: Pull complete 
    a0dbade8ea9b: Pull complete 
    5f20fde1ca5c: Pull complete 
    e1eebfeed5db: Pull complete 
    Digest: sha256:464e78f92895fd026733ed012ec591e4fff7fe82b37f4255b70ec7a5d97d8e57
    Status: Downloaded newer image for websphere-liberty:webProfile8
    Yoshiki-no-MacBook-Air:Lab1 yoshiki$ 
    ```
1. `docker images` コマンドを入力し、ダウンロードしたLibertyのDockerイメージを確認します。
    ```
    Yoshiki-no-MacBook-Air:Lab2 yoshiki$ docker images
    REPOSITORY                                   TAG                 IMAGE ID            CREATED             SIZE
    websphere-liberty                            webProfile8         1fd43b4175ca        38 hours ago        500MB
    Yoshiki-no-MacBook-Air:Lab2 yoshiki$
    ```

## Libertyイメージの稼働確認と内容の確認
1. `docker run -d -p 19080:9080 --name wlp websphere-liberty:webProfile8` コマンドを入力し、Libertyのコンテナーを起動します。<br>
    `--name wlp` オプションで、コンテナーにwlpの名前をつけて起動しています。dockerコマンドで、コンテナーを指定する場合に、コンテナーIDの代わりに名前で、操作することができます。
    ```
    Yoshiki-no-MacBook-Air:Lab2 yoshiki$ docker run -d -p 19080:9080 --name wlp websphere-liberty:webProfile8
    c82c221a570f5808b657b8831626f0ad6eba722ab227ed7efd74ec8efde34a58
    Yoshiki-no-MacBook-Air:Lab2 yoshiki$
    ```
1. LibertyのwebProfileには、デフォルト・コンテキストルートのページが準備されていますので、ブラウザーのアドレス欄に `http://localhost:19080/` を入力しします。デフォルト・コンテキストルートのページが表示され、Libertyのコンテナーが稼働していることが確認できます。
1. Libertyのイメージには、下記の設定が行われています。
    - WAS Liberty を /opt/ibm/wlp にインストール(展開)
    - サーバー defaultServer を作成
    - ログ・ディレクトリーを /logs に変更 (環境変数 LOG_DIR)
    - 出力ディレクトリーを /opt/ibm/wlp/output に変更 (環境変数 WLP_OUTPUT_DIR)
    - ディレクトリー /logs を作成
    - 出力ディレクトリーへのリンク /output を作成
    - 構成ディレクトリーへのリンク /config を作成
    - server run defaultServer コマンドで、WAS Liberty を起動<br>
`docker exec -it wlp /bin/bash` のコマンドを入力し、Libertyコンテナーにログインし、設定を確認します。
    ```
    Yoshiki-no-MacBook-Air:Lab2 yoshiki$ docker exec -it wlp /bin/bash
    default@c82c221a570f:/$ 
    ```
    
1. 下記のコマンドを順に実行し、設定が行われているディレクトリーの内容とserver.xmlの内容を確認します。
- `ls -l /opt/ibm/wlp/`
- `ls -l /opt/ibm/wlp/usr/servers`
- `ls -l /opt/ibm/wlp/usr/servers/defaultServer/`
- `ls -l /logs`
- `ls -l /opt/ibm/wlp/output/`
- `ls -l /opt/ibm/wlp/output/defaultServer/`
- `ls -l /output`
- `ls -l /config`
- `cat /config/server.xml`

    ```
    default@c82c221a570f:/$ ls -l /opt/ibm/wlp/
    total 88
    -rw-rw-r-- 1 default root  5079 Sep  6 02:38 CHANGES.TXT
    -rw-rw-r-- 1 default root   332 Sep  6 02:03 Copyright.txt
    -rw-rw-r-- 1 default root 12410 Sep  6 02:38 README.TXT
    drwxrwxr-x 1 default root  4096 Oct 23 22:30 bin
    drwxr-xr-x 3 default root  4096 Oct 23 22:30 clients
    drwxrwxr-x 1 default root  4096 Sep  6 03:38 dev
    drwxrwxr-x 1 default root 16384 Oct 23 22:30 lafiles
    drwxrwxr-x 1 default root 20480 Oct 23 22:30 lib
    drwxrwx--T 1 default root  4096 Oct 26 23:30 output
    drwxrwxr-x 1 default root  4096 Sep  6 03:38 templates
    drwxrwxr-x 1 default root  4096 Sep  6 03:38 usr
    default@c82c221a570f:/$ 
    default@c82c221a570f:/$ ls -l /opt/ibm/wlp/usr/servers
    total 4
    drwxrwx--- 1 default root 4096 Oct 23 22:30 defaultServer
    default@c82c221a570f:/$
    default@c82c221a570f:/$ ls -l /opt/ibm/wlp/usr/servers/defaultServer/
    total 20
    drwxrwx--- 1 default root 4096 Oct 23 22:22 apps
    drwxrwxr-x 1 default root 4096 Oct 23 22:22 configDropins
    drwxrwx--- 1 default root 4096 Oct 23 22:22 dropins
    -rw-rw---- 1 default root   67 Oct 23 22:22 server.env
    -rw-rw-r-- 1 root    root  549 Oct 23 22:30 server.xml
    default@c82c221a570f:/$
    default@c82c221a570f:/$ ls -l /logs
    total 8
    -rw-r----- 1 default root 5115 Oct 28 13:43 messages.log
    default@c82c221a570f:/$
    default@c82c221a570f:/$ ls -l /opt/ibm/wlp/output/
    total 4
    drwxrwx--- 1 default root 4096 Oct 26 23:30 defaultServer
    default@c82c221a570f:/$
    default@c82c221a570f:/$ ls -l /opt/ibm/wlp/output/defaultServer/
    total 12
    drwxr-x--- 1 default root 4096 Oct 28 13:42 logs
    drwxr-x--- 1 default root 4096 Oct 28 13:43 resources
    drwxr-x--- 1 default root 4096 Oct 28 13:42 workarea
    default@c82c221a570f:/$
    default@c82c221a570f:/$ ls -l /output                               
    lrwxrwxrwx 1 root root 33 Oct 23 22:22 /output -> /opt/ibm/wlp/output/defaultServer
    default@c82c221a570f:/$
    default@c82c221a570f:/$ ls -l /config
    lrwxrwxrwx 1 default root 38 Oct 23 22:22 /config -> /opt/ibm/wlp/usr/servers/defaultServer
    default@c82c221a570f:/$
    default@c82c221a570f:/$ cat /config/server.xml
    <?xml version="1.0" encoding="UTF-8"?>
    <server description="Default server">
    
        <!-- Enable features -->
            <featureManager>
                <feature>webProfile-8.0</feature>
            </featureManager>
            
        <!-- To allow access to this server from a remote client host="*" has been added to the following element -->
        <httpEndpoint id="defaultHttpEndpoint"
                      host="*"
                      httpPort="9080"
                      httpsPort="9443" />

        <!-- Automatically expand WAR files and EAR files -->
        <applicationManager autoExpand="true"/>
        
    </server>
    default@c82c221a570f:/$ 
    ```
1. `exit` コマンドで、コンテナーからログオフします。
    ```
    default@c82c221a570f:/$ exit
    exit
    Yoshiki-no-MacBook-Air:Lab2 yoshiki$ 
    ```
1. Libertyのコンテナーを停止します。`docker stop wlp` コマンドを入力します。
    ```
    Yoshiki-no-MacBook-Air:Lab2 yoshiki$ docker stop wlp
    wlp
    Yoshiki-no-MacBook-Air:Lab2 yoshiki$ 
    ```
1. Libertyのコンテナーを削除します。`docker rm wlp` コマンドを入力します。
    ```
    Yoshiki-no-MacBook-Air:Lab2 yoshiki$ docker rm wlp
    wlp
    Yoshiki-no-MacBook-Air:Lab2 yoshiki$ 
    ```
    
## アプリをデプロイしたDockerイメージの作成
1. Lab2ディレクトリーには、サンプル・アプリケーション(Sum.war)、Libertyの構成ファイル(server.xml)、Dockerイメージのビルド・ファイル(Dockerfile)が準備されています。
1. Sum.warは、Servlet 1ファイルとJSP 1ファイルから構成され、2つの数字の入力の足し算の結果を返す簡単なWebアプリケーションです。<br>
    /Sumのエンドポイントにアクセスすると下記の画面が表示され、数値を入力し、"Submit"ボタンを押すと、結果が表示されます。<br>
    
1. server.xmlは、下記のように、`webProfile-8.0`だけでなく、`mpMetrics-1.1`, `monitor-1.0`のフィーチャーを追加しています。
    ```xml:server.xml
    <?xml version="1.0" encoding="UTF-8"?>
    <server description="new server">
    
      <!-- Enable features -->
      <featureManager>
        <feature>webProfile-8.0</feature>
        <feature>mpMetrics-1.1</feature>
        <feature>monitor-1.0</feature>
      </featureManager>
      
      <!-- To access this server from a remote client add a host attribute to the following element, e.g. host="*" -->
      <httpEndpoint id="defaultHttpEndpoint"
              host="*"
              httpPort="9080"
              httpsPort="9443" />
              
      <!-- Automatically expand WAR files and EAR files -->
      <applicationManager autoExpand="true"/>
      
      <webContainer setContentLengthOnClose="false"/>
      <mpMetrics authentication="false"/>
      
    </server>
    ```
1. Dockerfileを、テキスト・エディター、または、`cat Dockerfile`で内容を表示します。
    ```
    Yoshiki-no-MacBook-Air:Lab2 yoshiki$ cat Dockerfile
    FROM websphere-liberty:webProfile8
    COPY Sum.war /config/dropins/
    COPY server.xml /config/
    RUN installUtility install --acceptLicense defaultServer
    Yoshiki-no-MacBook-Air:Lab2 yoshiki$
    ```
1. `docker build` コマンドを実行することで、Dockerfileの内容に基づいて、Dockerイメージが生成されます。<br>
    - 1行目のFROMコマンドで、新しいDockerイメージの元になるDockerイメージを指定しています。この例では、先ほど、稼働確認、内容を確認した、websphere-liberty:webProfile8 のイメージをベースにしています。
    - 2行目のCOPYコマンドで、ローカルPCのSum.warファイルを、新しいDockerコンテナーの /config/dropins/ ディレクトリーにコピーしています。つまり、warファイルのデプロイを行なっています。
    - 3行目のCOPYコマンドでは、Libertyの設定ファイルであるserver.xmlを、新しいDockerコンテナーの/config/ ディレクトリーにコピーしています。つまり、Libertyの設定を行なっています。
    - 最後の4行目のRUNコマンドでは、新しいDockerコンテナー上で、コマンド 'installUtility install --acceptLicense defaultServer' を実行しています。'installUtility install'は、Libertyのコマンドであり、server.xmlの記述に基づき、現在のLibertyのインストールに不足するLibertyフィーチャーを、インターネット上で提供されるLiberty repositoryにアクセスして、ダウンロード、インストールします。
1. `docker build -t mylibertyapp:1.0 .` コマンドを入力し、Dockerイメージをビルドします。<br>
    `-t  mylibertyapp:1.0` オプションで、作成するDockerイメージと名前(mylibertyapp)とタグ(1.0)を指定しています。最後の`.`を忘れないでください。`docker build` コマンドの最後の引数に、DockerfileのパスまたはURLを指定します。今回は、ローカルのカレント・ディレクトリーのDockerfileを使用してDockerイメージのビルドを行うため、`.` を指定しています。
    ```
    Yoshiki-no-MacBook-Air:Lab2 yoshiki$ docker build -t mylibertyapp:1.0 .
    Sending build context to Docker daemon  20.99kB
    Step 1/4 : FROM websphere-liberty:webProfile8
    　---> 1fd43b4175ca
    Step 2/4 : COPY Sum.war /config/dropins/
    　---> Using cache
    　---> 6e6153e170a0
    Step 3/4 : COPY server.xml /config/
    　---> e56aeb86df4d
    Step 4/4 : RUN installUtility install --acceptLicense defaultServer
    　---> Running in b3de811ebd89
    Checking for missing features required by the server ...
    The server requires the following additional features: mpmetrics-1.1.  Installing features from the repository ...
    Establishing a connection to the configured repositories ...
    This process might take several minutes to complete.
    
    Successfully connected to all configured repositories.
    
    Preparing assets for installation. This process might take several minutes to complete.
    
    Additional Liberty features must be installed for this server.
    
    To install the additional features, review and accept the feature license agreement:
    The --acceptLicense argument was found. This indicates that you have
    accepted the terms of the license agreement.
    
    
    Step 1 of 8: Downloading mpConfig-1.2 ...
    Step 2 of 8: Installing mpConfig-1.2 ...
    Step 3 of 8: Downloading cdi-1.2 ...
    Step 4 of 8: Installing cdi-1.2 ...
    Step 5 of 8: Downloading mpMetrics-1.1 ...
    Step 6 of 8: Installing mpMetrics-1.1 ...
    Step 7 of 8: Validating installed fixes ...
    Step 8 of 8: Cleaning up temporary files ...
    
    
    All assets were successfully installed.
    
    Start product validation...
    Product validation completed successfully.
    Removing intermediate container b3de811ebd89
    　---> 4027ff6ba2c0
    Successfully built 4027ff6ba2c0
    Successfully tagged mylibertyapp:1.0
    Yoshiki-no-MacBook-Air:Lab2 yoshiki$  
    ```
1. `docker images` コマンドを入力し、名前mylibertyappのイメージが追加されていることを確認します。
    ```
    Yoshiki-no-MacBook-Air:Lab2 yoshiki$ docker images
    REPOSITORY                                   TAG                 IMAGE ID            CREATED             SIZE
    mylibertyapp                                 1.0                 4027ff6ba2c0        3 minutes ago       508MB
    websphere-liberty                            webProfile8         1fd43b4175ca        41 hours ago        500MB
    Yoshiki-no-MacBook-Air:Lab2 yoshiki$
    ```
## 作成したイメージの稼働確認
1. `docker run -d -p 19080:9080 --name=mywlp mylibertyapp:1.0` コマンドを入力し、Dockerコンテナーを起動します。
    ```
    Yoshiki-no-MacBook-Air:Lab2 yoshiki$ docker run -d -p 19080:9080 --name=mywlp mylibertyapp:1.0
    a04c4b5fe647482cf6471282bd73ff68e4e9ba7e54ea29f7e55a75f7ef217565
    Yoshiki-no-MacBook-Air:Lab2 yoshiki$ 
    ```
1. `docker logs -f mywlp` コマンドを入力し、コンテナーの標準出力をtailします。"[AUDIT   ] CWWKF0011I: The server defaultServer is ready to run a smarter planet."が表示されると、Libertyの起動が完了です。
    ```
    Yoshiki-no-MacBook-Air:Lab2 yoshiki$ docker logs -f mywlp
    Launching defaultServer (WebSphere Application Server 18.0.0.3/wlp-1.0.22.cl180320180905-2337) on IBM J9 VM, version 8.0.5.22 - pxa6480sr5fp22-20180919_01(SR5 FP22) (en_US)
    [AUDIT   ] CWWKE0001I: The server defaultServer has been launched.
    [AUDIT   ] CWWKE0100I: This product is licensed for development, and limited production use. The full license terms can be viewed here: https://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/wasdev/license/base_ilan/ilan/18.0.0.3/lafiles/en.html
    [AUDIT   ] CWWKG0093A: Processing configuration drop-ins resource: /opt/ibm/wlp/usr/servers/defaultServer/configDropins/defaults/keystore.xml
    [AUDIT   ] CWWKZ0058I: Monitoring dropins for applications.
    [AUDIT   ] CWWKS4104A: LTPA keys created in 2.084 seconds. LTPA key file: /opt/ibm/wlp/output/defaultServer/resources/security/ltpa.keys
    [AUDIT   ] CWPKI0803A: SSL certificate created in 3.754 seconds. SSL key file: /opt/ibm/wlp/output/defaultServer/resources/security/key.jks
    [AUDIT   ] CWWKT0016I: Web application available (default_host): http://e29941f3d4fc:9080/metrics/
    [AUDIT   ] CWWKT0016I: Web application available (default_host): http://e29941f3d4fc:9080/ibm/api/
    [AUDIT   ] CWWKT0016I: Web application available (default_host): http://e29941f3d4fc:9080/Sum/
    [AUDIT   ] CWWKZ0001I: Application Sum started in 2.049 seconds.
    [AUDIT   ] CWWKF0012I: The server installed the following features: [beanValidation-2.0, servlet-4.0, ssl-1.0, jndi-1.0, cdi-2.0, jdbc-4.2, appSecurity-3.0, appSecurity-2.0, jaxrs-2.1, mpMetrics-1.1, webProfile-8.0, jpa-2.2, jsp-2.3, jsonb-1.0, ejbLite-3.2, managedBeans-1.0, jsf-2.3, jsonp-1.1, mpConfig-1.2, jaxrsClient-2.1, el-3.0, jpaContainer-2.2, json-1.0, jaspic-1.1, distributedMap-1.0, websocket-1.1].
    [AUDIT   ] CWWKF0011I: The server defaultServer is ready to run a smarter planet.
    ```
1. [Ctrl]+c で、logのtailを終了します。
1. ブラウザーで、`http://localhost:19080/Sum` にアクセスし、サンプル・アプリケーションが表示されることを確認します。
1. また、今回、mpMetrics-1.1 (MicroProfile Metrics)のフィーチャーを追加していますので、ブラウザーで、`http://localhost:19080/metrics`にアクセスすることでサーバーのGC状況やLibertyのWebコンテナー・スレッド数、HTTPセッションの統計情報が表示されます。

以上で、Lab2は終了です。引き続き、Lab3で、IBM提供のLiberty Helmチャートをデプロイし、IBM Cloud Privateのコンソール操作の体験と、Kubernetesのオブジェクトを確認します。





