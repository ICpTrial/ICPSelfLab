# Lab1. ローカルPC上でのDockerの基本操作

このLabでは、Ubuntu 上のDocker (Docker for WindowsやDocker for Mac) で、Apache httpdのイメージを使用して、Dockerの基礎を学習します。

## 前提

このLabでは、下記の準備を前提としています。
- IBM Cloud上に 導入された Ubuntu環境、docker-ceが導入しています。
- インターネットに接続できる環境

所用時間は、およそ20分です。

## Docker環境の確認

1. ハンズオン環境へのログイン

    1. 手元のPCがのSSHクライアントを立ち上げ、指定された認証情報でログインしてください。
    
    ```
    ssh username@hostname
    ```
    
    1. このLabの作業ディレクトリー (C:¥Handson¥Lab1) に移動します。このディレクトリーには、下記のファイルが事前に準備されています。
        - index.html : Apache httpd稼働確認用のhtmlファイル

1. Docker環境の確認
    1. コマンドプロンプトで、 `docker version` コマンドを入力します。Dockerエンジンのバージョンが表示されます。
        ```
        $root@icp11master:~# docker version
        Client:
         Version:      18.03.1-ce
         API version:  1.37
         Go version:   go1.9.5
         Git commit:   9ee9f40
         Built:        Thu Apr 26 07:17:20 2018
         OS/Arch:      linux/amd64
         Experimental: false
         Orchestrator: swarm
        
        Server:
         Engine:
          Version:      18.03.1-ce
          API version:  1.37 (minimum version 1.12)
          Go version:   go1.9.5
          Git commit:   9ee9f40
          Built:        Thu Apr 26 07:15:30 2018
          OS/Arch:      linux/amd64
          Experimental: false
        $ 
        ```

    1. 単に `docker` コマンドを入力することで、dockerコマンドのヘルプが、`docker COMMAND --help` と入力することで、`docker run` や `docker build` コマンドのヘルプを表示することができます。
    
## Apache httpdイメージのPull(ダウンロード)
1. `docker pull httpd` コマンドを入力し、Apache httpdのDockerイメージを、ローカルPCのDockerレジストリーにダウンロードします。
    ```
    $ docker pull httpd
    Using default tag: latest
    latest: Pulling from library/httpd
    f17d81b4b692: Pull complete 
    06fe09255c64: Pull complete 
    0baf8127507d: Pull complete 
    07b9730387a3: Pull complete 
    6dbdee9d6fa5: Pull complete 
    Digest: sha256:90b34f4370518872de4ac1af696a90d982fe99b0f30c9be994964f49a6e2f421
    Status: Downloaded newer image for httpd:latest
    $ 
    ```
    デフォルトでは、Docker Storeから、ダウンロードされます。
1. `docker images httpd` コマンドを入力し、ダウンロードしたhttpdのDockerイメージを確認します。

    ```
    $ docker images httpd           
    REPOSITORY                                   TAG                 IMAGE ID            CREATED             SIZE
    httpd                                        latest              55a118e2a010        3 days ago          132MB
    $ 
    ```

## httpdのDockerコンテナーの起動とホストOSとのポートマッピング

1. `docker run (options) <Image_Name(:Tag)>` コマンドでコンテナーを フォアグラウンドで 起動します。
`-p (ホストOSのマッピング・ポート):(ゲストOSのポート)`オプションで、公開するコンテナーのゲストOSのポートと、ホストOS上のポートをマッピングします。

下記の `docker run -p 10080:80 httpd` の例では、httpdが公開する80番ポートを、ホストOSの10080番ポートにマッピングしています。この 'docker run' コマンドでは、フォアグラウンドでコンテナーを起動していますので、コンテナー起動中はプロンプトが戻らず、標準出力、標準エラー出力が、コンソール上に表示されます。<br>

    $ docker run -p 10080:80 httpd
    AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 172.17.0.2. Set the 'ServerName' directive globally to suppress this message
    AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 172.17.0.2. Set the 'ServerName' directive globally to suppress this message
    [Sun Oct 28 09:37:01.473062 2018] [mpm_event:notice] [pid 1:tid 140003993466048] AH00489: Apache/2.4.37 (Unix) configured -- resuming normal operations
    [Sun Oct 28 09:37:01.473507 2018] [core:notice] [pid 1:tid 140003993466048] AH00094: Command line: 'httpd -D FOREGROUND'
    

起動を確認したら、一旦 `Ctrl+C` で終了します。<br>


1. `docker run -d (options) <Image_Name(:Tag)>` コマンドでコンテナーを バックグラウンドで起動します。

今度はバックグラウンドで起動します。バックグラウンドで起動するには -d オプションを渡します。

    ```
    $ docker run -d -p 10080:80 httpd
    9ac73561ced434e100c33218e007404007d6a936c2077c80be98d4fc73f801e6
    ```
帰り値として、docker のコンテナーIDが返されます。`docker ps`で docker プロセスの状況を確認します。<br>

    $ docker ps | grep httpd
    9ac73561ced4        httpd                                            "httpd-foreground"       6 minutes ago       Up 5
    minutes       0.0.0.0:10080->80/tcp   hopeful_brattain


1.　curl で httpdのコンテナーが稼働していることを確認します。

    $ curl http://localhost:10080/
    <html><body><h1>It works!</h1></body></html>

1. `docker exec -it <コンテナID> /bin/bash` で、起動した コンテナにログインしてみます。
   
コンテナIDには先ほど docker ps で確認してコンテナIDを指定してください。前方一致で判断されますので、前方数桁を指定すればOKです。
`hostname` や `cat htdocs/index.html` ログインしたコンテナで 叩いて見てください。

    # docker exec -it 9ac /bin/bash
    root@9ac73561ced4:/usr/local/apache2# hostname
    9ac73561ced4
    root@9ac73561ced4:/usr/local/apache2# ls htdocs
    index.html
    root@9ac73561ced4:/usr/local/apache2# cat htdocs/index.html
    <html><body><h1>It works!</h1></body></html>
    root@9ac73561ced4:/usr/local/apache2# exit
 
    
実際には、指定されたコンテナIDで /bin/bash を実行していることになります。
最後 `exit` してコンテナから抜けます。

1. コンテナにディスク領域をマウントしてみます

1-1.今度は、コンテナに ローカル・ディスクの領域をマウントさせてみます。
まず準備として、ローカルの /work/contents ディレクトリ配下に HTTPで表示する用のindex.htmlファイルを作成します

    mkdir -p /work/contents
    echo "<html><body><h1>Local Contents</h1></body></html>" >> /work/contents/index.html


1-1.次に -v オプションで 作成したコンテンツをマウントさせて、起動します。
なお、先ほどの10080 ポート はまだ使用されていますので、10081を指定しましょう。

    $ ~# docker run -d -p 10081:80 -v "/work/contents/:/usr/local/apache2/htdocs/" httpd
    69a5a4d63140d87cf39b1d41e8d01c3c8827de30fa7b8a3027634f8a509ba159
    $ curl http://localhost:10081/
    <html><body><h1>Local Contents</h1></body></html>
    
先ほど作成したコンテンツが 返されていることを確認します。<br>

1-1あらためて、docker ps で確認してコンテナIDを確認します。
    ```
    root@icp11master:~# docker ps | grep httpd
    69a5a4d63140        httpd                                            "httpd-foreground"       2 hours ago         Up 2 hours          0.0.0.0:10081->80/tcp   youthful_sammet
    9ac73561ced4        httpd                                            "httpd-foreground"       2 hours ago         Up 2 hours          0.0.0.0:10080->80/tcp   hopeful_brattain
    ```
    


指定してください。前方一致で判断されますので、前方数桁を指定すればOKです。
`hostname` や `cat htdocs/index.html` ログインしたコンテナで 叩いて見てください。

    # docker exec -it 9ac /bin/bash
    root@9ac73561ced4:/usr/local/apache2# hostname
    9ac73561ced4
    root@9ac73561ced4:/usr/local/apache2# ls htdocs
    index.html
    root@9ac73561ced4:/usr/local/apache2# cat htdocs/index.html
    <html><body><h1>It works!</h1></body></html>
    root@9ac73561ced4:/usr/local/apache2# exit
    
## DockerコンテナーのゲストOSへのログイン
1. '-d' オプションを付与して、httpdのコンテナーを起動していますので、バックグラウンドで、コンテナーが起動しています。`docker ps` コマンドで、現在稼働中のdockerコンテナーを表示できます。
```
    $ docker ps
    CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS                   NAMES
    99a58c8b3bba        httpd               "httpd-foreground"   18 seconds ago      Up 17 seconds       0.0.0.0:20080->80/tcp   inspiring_bassi
    $ 
```

1. `docker logs <CONTAINER ID>` で標準出力、標準エラー出力を表示することができます。

    $ docker logs 99a58c8b3bba
    AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 172.17.0.2. Set the 'ServerName' directive globally to suppress this message
    AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 172.17.0.2. Set the 'ServerName' directive globally to suppress this message
    [Sun Oct 28 10:45:14.202693 2018] [mpm_event:notice] [pid 1:tid 139755424806080] AH00489: Apache/2.4.37 (Unix) configured -- resuming normal operations
    [Sun Oct 28 10:45:14.202869 2018] [core:notice] [pid 1:tid 139755424806080] AH00094: Command line: 'httpd -D FOREGROUND'
    172.17.0.1 - - [28/Oct/2018:10:45:23 +0000] "GET / HTTP/1.1" 200 49
    172.17.0.1 - - [28/Oct/2018:10:45:23 +0000] "GET /favicon.ico HTTP/1.1" 404 209
    $ 

1. `docker exec` コマンドで、起動中のコンテナーOS上で、コマンドを実行することができます。これを利用して、`docker exec -it <CONTAINER ID> /bin/bash` コマンドを実行することで、コンテナーOSにログインすることができます。
    ```
    $ docker exec -it 99a58c8b3bba /bin/bash
    root@99a58c8b3bba:/usr/local/apache2# 
    ```
1. `pwd` や `ls` 、`uname -a` コマンドなど、任意のコマンドを実行してみてください。
1. `exit` コマンドで、コンテナーOSのターミナルを終了し、元の自身のPCのターミナルに戻ります。
    ```
    root@99a58c8b3bba:/usr/local/apache2# exit
    exit
    $ 
    ```

## コンテナーの停止と削除
1. `docker stop <CONTAINER ID>` コマンドで、起動中のコンテナーを停止します。`<CONTAINER ID>`の確認には、`docker ps`コマンドを入力してください。
    ```
    $ docker stop 99a58c8b3bba
    99a58c8b3bba
    $ 
    ```
1. `docker ps` コマンドで、起動中のコンテナーが存在せず、正しく停止されたことを確認します。
    ```
    $ docker ps
    CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
    $
    ```
    もし、コンテナーが正しく停止できなかった場合には、`docker kill <CONTAINER ID>` コマンドで、コンテナーを強制終了します。
1. `docker ps -a` コマンドを入力することで、停止しているコンテナーも含めて、表示することができます。最初に10080番ポートにマッピングした、フォアグラウンドで起動し、[Ctrl]+cで停止したコンテナーと、20080番ポートにマッピングした、バックグランドで起動し、docker stopで停止したコンテナーの2つのコンテナーが表示されます。
    ```
    $ docker ps -a
    CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS                         PORTS               NAMES
    99a58c8b3bba        httpd               "httpd-foreground"   About an hour ago   Exited (0) 4 minutes ago                           inspiring_bassi
    dfc909c6e577        httpd               "httpd-foreground"   2 hours ago         Exited (0) 2 hours ago                             eager_zhukovsky
    $ 
    ```
1. 停止したコンテナーを、再度、docker startコマンドで起動することもできますが、Dockerのコンテナーは、一度作成したコンテナーに変更を加えていくことは推奨されず、元のイメージから再度作り直すことがベストプラクティスです。今回のハンズオンでも停止したコンテナーを再度利用することはありませんので、`docker rm <CONTAINER ID>` コマンドで、停止しているコンテナーを削除します。<CONTAINER ID> は、複数のCONTAINER IDをリスト形式で並べて記述することも可能です。
    ```
    $ docker rm 99a58c8b3bba dfc909c6e577
    99a58c8b3bba
    dfc909c6e577
    $ 
    ```
1. `docker ps -a` コマンドで、停止中のコンテナーが存在しなくなったことを確認します。
    ```
    $ docker ps -a
    CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
    $
    ```
1. 今回のLabの最初にdocker pullでダウンロードした、httpdのコンテナー・イメージを削除します。Dockerイメージの削除は、`docker rmi <Image_Name(:Tag)>` コマンドで削除します。`docker images`、`docker rmi httpd`、`docker images`の順にコマンドを入力することで、httpdのDockerイメージの削除が行われたことを確認することができます。
    ```
    $ docker rmi httpd
    Untagged: httpd:latest
    Untagged: httpd@sha256:90b34f4370518872de4ac1af696a90d982fe99b0f30c9be994964f49a6e2f421
    Deleted: sha256:55a118e2a010d079e6fcfff7b182715f0abf2613ab2bd496a95cdd0b0e8dc998
    Deleted: sha256:76cc0839bd0b535504fb11312953692fe3d07c981b24df34650e8acfb48e5e19
    Deleted: sha256:96e93d15e8ff1903bbb8ef9c1bc96697f582d8be452dc6ff129cc7fb59adfb5e
    Deleted: sha256:8be1738a03f4e4c8d1001419fddc6b4255439f279fcdaee1ca68a809e9dc1ca0
    Deleted: sha256:69db4316d3fcd395a6c8f97a99664fb764af1e6201aaebabea34e41b1c59118f
    Deleted: sha256:237472299760d6726d376385edd9e79c310fe91d794bc9870d038417d448c2d5
    $
    ```

以上で、Lab1は終了です。引き続き、Lab2で、Libertyにアプリをデプロイした独自のDockerイメージを作成します。


