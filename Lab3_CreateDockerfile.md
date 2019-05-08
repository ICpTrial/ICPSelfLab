# Lab3. Dockerイメージのカスタマイズ

このLabでは、WebSphere Libertyの Dockerイメージを元に、独自のアプリをデプロイしたDockerイメージを作成します。

## 前提

この Lab3では、Lab2で利用したDocker環境を利用して、ハンズオンを実施します。

所用時間は、およそ30分です。

## ハンズオン環境の準備

1. 以下の３つのファイルをダウンロードし、`scp` コマンドで ハンズオン環境の `/work/lab3` にアップロードしてください。
    - Sum.war : Libertyのサンプル・アプリケーション
    - server.xml : サンプル・アプリケーション用のLibertyの構成ファイル
    - Dockerfile : サンプル・アプリケーションがデプロイされたDockerイメージをビルドするためのDockerfile
    
    1. 作業ディレクトリを作成します。
    ```
    # mkdir -p /work/lab3
    ```
    1. ハンズオン・マテリアル lab3material.tar は[こちら](https://github.com/ICpTrial/ICPSelfLab/raw/master/lab3material.tar)にありますので、ダウンロードしてください。
    1. 作成した作業ディレクトリにアップロードします。
    ```
    (作業PCで実施）
    $ scp lab3material.tar root@<machine_ip>:/work/lab3
    ```
    1.
    ```
    # cd /work/lab3
    # tar -xvf lab3material.tar
    ```

## ハンズオン環境の準備

1. このハンズオンでは、IBMのJavaEEアプリケーション・サーバーである **WebSphere Liberty** を利用します。<br>
フルスタックのJavaEEをサポートしながらも、各種APIや機能がフィーチャーとしてモジュール化されているため、必要な機能のみを有効化し、より少ないリソースで利用していくことが可能な軽量アプリケーション・サーバーです。<br><br>
LibertyのDockerイメージは、javaee8（JavaEEフルプロファイルをサポートするもの）やkernel（Libertyカーネルのみ）など、複数のタグ付けされたイメージが公開されています。また、これらのDockerイメージをビルドするのに利用されている Dockerfileもあわせて公開されています<br>
以下のサイトを開き、製品として提供されている Dockerfileが どのように構成されているか確認してみます。<br>
    [docker store: IBM WebSphere Application Server Liberty](https://store.docker.com/images/websphere-liberty)
    
    1. このハンズオンでは、javaee8 WebProfileに対応した websphere-liberty:webProfile8 の最新バージョン を利用します。<br>
    　　websphere-liberty:webProfile8 の dockerfileを確認してみます。<br>
       websphere-liberty:kernel をベース・イメージとして、フィーチャーを追加するコマンドを実行し、デフォルトのserverl.xmlファイルを配置していることがわかります。
    1. 次に websphere-liberty:kernel のdockerfile を確認してみます。<br>こちらは ibm-java:8-jre と Java8のランタイムをベースにビルドされていることがわかります。
    1. さらに 以下が IBM Javaの docker ファイルです。Ubuntuのベースイメージに対して、JREを導入していることがわかります。<br>
    [docker hub: ibmjava](https://hub.docker.com/_/ibmjava/)
    
   このように階層化された環境を利用することにより、各レイヤーでの変更を、イメージをビルドするタイミングで取り込めるよう構成されています。
   貴社の製品のコンテナを構成する際の参考としてください。
 
## Liberty WebProfile イメージの取得
それでは、実際に docker イメージに ユーザーのアプリケーションを構成して、コンテナをビルドしていきます。 

1. `docker pull websphere-liberty:webProfile8` コマンドを入力し、WebSphere LibertyのwebProfile8のイメージをダウンロードします。<br>
    
    ```
    # docker pull websphere-liberty:webProfile8
    webProfile8: Pulling from library/websphere-liberty
    7b8b6451c85f: Pull complete
    ab4d1096d9ba: Pull complete
    e6797d1788ac: Pull complete
    e25c5c290bde: Pull complete
    27b2fbbc72b1: Pull complete
    aa35dfd74487: Pull complete
    01e6f5fdb27a: Pull complete
    ce9d285837ba: Pull complete
    030b23ca6769: Pull complete
    e3e36b4e51c8: Pull complete
    c5a95ff4c3e2: Pull complete
    51efc95fded4: Pull complete
    b39a411b99b2: Pull complete
    fffee45b6572: Pull complete
    cd3deffcbc24: Pull complete
    Digest: sha256:fdb438215af57d662434763bd604d7714fe12e378a53b3e8792d5f874aed3375
    Status: Downloaded newer image for websphere-liberty:webProfile8
    ```
1. `docker images` コマンドを入力し、ダウンロードしたLibertyのDockerイメージを確認します。
    ```
    # docker images | grep liberty
    REPOSITORY                                   TAG                 IMAGE ID            CREATED             SIZE
    websphere-liberty                            webProfile8         1fd43b4175ca        38 hours ago        500MB
    ```

## Libertyイメージの稼働確認と内容の確認
1. `docker run -d -p19080:9080 --name wlp websphere-liberty:webProfile8` コマンドを入力し、Libertyのコンテナーを起動します。<br>
    `--name wlp` オプションで、コンテナーにwlpの名前をつけて起動しています。
    dockerコマンドで、コンテナーを指定する場合に、コンテナーIDの代わりに名前で操作することができます。
    ```
    # docker run -d -p19080:9080 --name wlp websphere-liberty:webProfile8
    c82c221a570f5808b657b8831626f0ad6eba722ab227ed7efd74ec8efde34a58
    ```
    
    1.デフォルトイメージの稼働確認
    LibertyのwebProfileには デフォルト・コンテキストルート(/) のページが準備されています。
    ブラウザーのアドレス欄に `http://<ハンズオン・サーバーIPアドレス>:19080/` を入力します。
    
    デフォルト・コンテキストルートのページが表示され、Libertyのコンテナーが稼働していることが確認できます。表示されるページのデザインは、リリースにより異なることがありますので、以下のイメージと変更になっているかもしれません。
    ![LibertyDefaultTop](https://github.com/ICpTrial/ICPLab/blob/master/images/Lab2/Lab2_01_LibertyDefaultPage.png)


1. Libertyの製品イメージには、下記の設定が行われています。<br>
　 ※ここは製品の設定を確認しているだけですので、ここはスキップ可能です。<br>
    興味がある方は、先程のいくつかのコンテナのどの層の dockerfile で設定されているか確認してみてください。
    - WAS Liberty を /opt/ibm/wlp にインストール(展開)
    - サーバー defaultServer を作成
    - ログ・ディレクトリーを /logs に変更 (環境変数 LOG_DIR の設定)
    - 出力ディレクトリーを /opt/ibm/wlp/output に変更 (環境変数 WLP_OUTPUT_DIR　の設定)
    - ディレクトリー /logs を作成
    - 出力ディレクトリーへのリンク /output を作成
    - 構成ディレクトリーへのリンク /config を作成
    - server run defaultServer コマンドで、WAS Liberty を起動<br><br>
        
    1. `docker exec -it wlp /bin/bash` のコマンドを入力し、Libertyコンテナーにログインし、設定を確認します。
    ```
    # docker exec -it wlp /bin/bash
    default@c82c221a570f:/$ 
    ```
    
    1. 下記のコマンドを順に実行し、設定が行われているディレクトリーの内容と`server.xml`の内容を確認します。
    - `ls -l /opt/ibm/wlp/`
    - `ls -l /opt/ibm/wlp/usr/servers`
    - `ls -l /opt/ibm/wlp/usr/servers/defaultServer/`
    - `ls -l /logs`
    - `ls -l /opt/ibm/wlp/output/`
    - `ls -l /opt/ibm/wlp/output/defaultServer/`
    - `ls -l /output`
    - `ls -l /config`
    - `echo $LOG_DIR`
    - `echo $WLP_OUTPUT_DIR`
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
    default@c82c221a570f:/$ echo $LOG_DIR
    /logs
    default@c82c221a570f:/$ echo $WLP_OUTPUT_DIR
    /opt/ibm/wlp/output
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
    $ 
    ```
 1. Libertyのコンテナー・インスタンスを停止します。`docker stop wlp` コマンドを入力します。
    ```
    $ docker stop wlp
    wlp
    $ 
    ```
    1. Libertyのコンテナー・インスタンスを削除します。`docker rm wlp` コマンドを入力します。
    ```
    $ docker rm wlp
    wlp
    $ 
    ```
    
## ユーザーのアプリをデプロイしたカスタマイズされたDockerイメージの作成（ビルド）

1. /work/lab3 にアプロードした サンプル・アプリケーション(Sum.war)、Libertyの構成ファイル(server.xml)、Dockerイメージのビルド・ファイル(Dockerfile) を利用して、カスタマイズした（ユーザーのアプリケーションが導入された）Docker イメージを作成していきます。
 
    1. Sum.warは、Servlet 1ファイルとJSP 1ファイルから構成され、2つの数字の入力の足し算の結果を返す簡単なWebアプリケーションです。<br>
       /Sumのエンドポイントにアクセスすると下記の画面が表示され、数値を入力し、"Submit"ボタンを押すと、結果が表示されます。<br>
        ![SumTop](https://github.com/ICpTrial/ICPLab/blob/master/images/Lab2/Lab2_02_SumTop.png)
        ![SumResult](https://github.com/ICpTrial/ICPLab/blob/master/images/Lab2/Lab2_03_SumResult.png)
        
    1. アプリケーション・サーバーの構成ファイル server.xml には、下記のように、`webProfile-8.0`だけでなく、`mpMetrics-1.1`, `monitor-1.0`のフィーチャーを追加しています。
   
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
    # cat Dockerfile
    FROM websphere-liberty:webProfile8
    COPY --chown=1001:0 Sum.war /config/dropins/
    COPY --chown=1001:0 server.xml /config/
    RUN installUtility install --acceptLicense defaultServer
    ```
1. `docker build` コマンドを実行することで、Dockerfileの内容に基づいて、Dockerイメージが生成されます。<br>
    - 1行目のFROMコマンドで、新しいDockerイメージの元になるDockerイメージを指定しています。この例では、先ほど、稼働確認、内容を確認した、websphere-liberty:webProfile8 のイメージをベースにしています。
    - 2行目のCOPYコマンドで、ローカルPCの`Sum.war`ファイルを、新しいDockerコンテナーの`/config/dropins/`ディレクトリーにコピーしています。つまり、warファイルのデプロイを行なっています。特に指定しない場合はrootがオーナーとしてファイルがコピーされますが、`--chown`オプションでファイルのオーナーを指定することが可能です。
    - 3行目のCOPYコマンドでは、Libertyの設定ファイルである`server.xml`を、新しいDockerコンテナーの`/config/`ディレクトリーにコピーしています。つまり、Libertyの設定変更を行なっています。
    - 最後の4行目のRUNコマンドでは、新しいDockerコンテナー上で、コマンド `installUtility install --acceptLicense defaultServer` を実行しています。`installUtility install`は、Libertyのコマンドであり、server.xmlの記述に基づき、現在のLibertyのインストールに不足するLibertyフィーチャーを、インターネット上で提供されるLiberty repositoryにアクセスして、ダウンロード、インストールします。<br>
    
1. `docker build -f Dockerfile -t mylibertyapp:1.0 .` コマンドを入力し、Dockerイメージをビルドします。<br>
`-f  Dockerfile` オプションで、ビルドに利用するDockerファイルを指定します。
`-t  mylibertyapp:1.0` オプションで、作成するDockerイメージと名前(mylibertyapp)とタグ(1.0)を指定しています。<br>
`docker build` コマンドの最後の引数に DockerfileのパスまたはURLを指定します。今回は、ローカルのカレント・ディレクトリーが このコンテナをビルドする際のコンテキストとなるため、`.` を指定しています。`.`を忘れないでください。<br>
    
    ```
    # docker build -f Dockerfile -t mylibertyapp:1.0 .
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
    #
    ```
    
1. `docker images` コマンドを入力し、名前mylibertyappのイメージが追加されていることを確認します。
    ```
    # docker images | grep liberty
    REPOSITORY                                   TAG                 IMAGE ID            CREATED             SIZE
    mylibertyapp                                 1.0                 4027ff6ba2c0        3 minutes ago       508MB
    websphere-liberty                            webProfile8         1fd43b4175ca        41 hours ago        500MB
    #
    ```
    
## 作成したイメージの稼働確認
1. `docker run -d -p 19080:9080 --name=mywlp mylibertyapp:1.0` コマンドを入力し、Dockerコンテナーを起動します。
    ```
    # docker run -d -p 19080:9080 --name=mywlp mylibertyapp:1.0
    a04c4b5fe647482cf6471282bd73ff68e4e9ba7e54ea29f7e55a75f7ef217565
    # 
    ```
    
1. `docker logs -f mywlp` コマンドを入力し、コンテナーの標準出力をtailします。"[AUDIT   ] CWWKF0011I: The server defaultServer is ready to run a smarter planet."が表示されると、Libertyの起動が完了です。
    ```
    # docker logs -f mywlp
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
1. ブラウザーで、`http://<handon-server-IPaddress>:19080/Sum` にアクセスし、サンプル・アプリケーションが表示されることを確認します。
1. また、今回、mpMetrics-1.1 (MicroProfile Metrics)のフィーチャーを追加していますので、ブラウザーで、`http://<handon-server-IPaddress>:19080/metrics`にアクセスすることでサーバーのGC状況やLibertyのWebコンテナー・スレッド数、HTTPセッションの統計情報が表示されます。
![Metrics](https://github.com/ICpTrial/ICPLab/blob/master/images/Lab2/Lab2_04_Metrics.png)

1. 利用したコンテナを停止します。
   ```
   # docker stop mywlp
    mywlp
   # docker ps
    CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
   #
    ```
    
## 更新されたイメージの用意
あとのハンズオンで利用するために、アプリケーションを更新したバージョンの コンテナ・イメージも作成しておきます。

1. Dockerfile を複製して `Dockerfile2` を作成し、Dockerfile2 を編集し、デプロイするアプリケーションを Sum2.war に変更します。
    ```
    # cp Dockerfile Dockerfile2
    # vi Dockerfile2
    FROM websphere-liberty:webProfile8
    COPY --chown=1001:0 Sum2.war /config/dropins/   ##この行を編集
    COPY --chown=1001:0 server.xml /config/
    RUN installUtility install --acceptLicense defaultServer
    ```
1. Dockerfile2 を使って、コンテナ・イメージを `mylibertyapp:2.0` としてビルドします。
   ```
    # docker build -f Dockerfile2 -t mylibertyapp:2.0 .
   ```
1. ビルドされたイメージを 19081番ポートにバインドして、名前を `mywlp2` として起動します。
    ```
   # docker run -d -p 19081:9080 --name=mywlp2 mylibertyapp:2.0
    ```
1. ブラウザーで、`http://<handon-server-IPaddress>:19081/Sum` にアクセスし、背景色が変更されたサンプル・アプリケーションが表示されることを確認します。

1. 利用したイメージを停止します。
   ```
   # docker stop mywlp2
    mywlp2
   ```

以上で、Lab3は終了です。<br>
引き続き、Lab4で、このDocker環境上に IBM Cloud Private を導入していきます。
