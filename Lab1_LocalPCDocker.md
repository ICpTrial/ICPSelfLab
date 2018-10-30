# Lab1. ローカルPC上でのDockerの基本操作

このLabでは、ローカルPC上のDocker (Docker for WindowsやDocker for Mac) で、Apache httpdのイメージを使用して、Dockerの基礎を説明します。

## 前提

このLabでは、下記の準備を前提としています。
- Docker for WindowsまたはDocker for Macの導入
- インターネットに接続できる環境

所用時間は、およそ30分です。

## Docker環境の確認

1. ハンズオン環境の確認
    1. コマンド・プロンプトを起動します。
    1. このLabの作業ディレクトリー (C:¥Handson¥Lab1) に移動します。このディレクトリーには、下記のファイルが事前に準備されています。
        - index.html : Apache httpd稼働確認用のhtmlファイル

1. Docker環境の確認
    1. コマンドプロンプトで、 `docker version` コマンドを入力します。Dockerエンジンのバージョンが表示されます。
        ```
        $ docker version
        Client:
         Version:           18.06.1-ce
         API version:       1.38
         Go version:        go1.10.3
         Git commit:        e68fc7a
         Built:             Tue Aug 21 17:21:31 2018
         OS/Arch:           darwin/amd64
         Experimental:      false
        
        Server:
         Engine:
          Version:          18.06.1-ce
          API version:      1.38 (minimum version 1.12)
          Go version:       go1.10.3
          Git commit:       e68fc7a
          Built:            Tue Aug 21 17:29:02 2018
          OS/Arch:          linux/amd64
          Experimental:     true
         Kubernetes:
          Version:          Unknown
          StackAPI:         Unknown
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
1. `docker images` コマンドを入力し、ダウンロードしたhttpdのDockerイメージを確認します。
    ```
    $ docker images           
    REPOSITORY                                   TAG                 IMAGE ID            CREATED             SIZE
    httpd                                        latest              55a118e2a010        3 days ago          132MB
    $ 
    ```

## httpdのDockerコンテナーの起動とホストOSとのポートマッピング
##### 1. `docker run (options) <Image_Name(:Tag)>` コマンドでコンテナーを起動します。
コンテナーのゲストOSでリッスンしているポートは、デフォルトではホストOS上には公開されませんので、`-p (ホストOSのマッピング・ポート):(ゲストOSのポート)`オプションで、公開するコンテナーのゲストOSのポートと、ホストOS上のポートをマッピングします。下記の `docker run -p 10080:80 httpd` の例では、httpdが公開する80番ポートを、ホストOSの10080番ポートにマッピングしています。この 'docker run' コマンドでは、フォアグラウンドで、コンテナーを起動していますので、コンテナー起動中は、プロンプトが戻らず、標準出力、標準エラー出力が、コンソール上に表示されます。<br>

    ```
    $ docker run -p 10080:80 httpd
    AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 172.17.0.2. Set the 'ServerName' directive globally to suppress this message
    AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 172.17.0.2. Set the 'ServerName' directive globally to suppress this message
    [Sun Oct 28 09:37:01.473062 2018] [mpm_event:notice] [pid 1:tid 140003993466048] AH00489: Apache/2.4.37 (Unix) configured -- resuming normal operations
    [Sun Oct 28 09:37:01.473507 2018] [core:notice] [pid 1:tid 140003993466048] AH00094: Command line: 'httpd -D FOREGROUND'
    ```
    
##### 2.　ブラウザーを起動し、アドレス欄に `http://localhost:10080/` を入力し、コンテナーのhttpdのトップページにアクセスします。'It works!'と表示され、httpdのコンテナーが稼働していることが確認できます。
![httpdTop](https://github.com/ICpTrial/ICPLab/blob/master/images/Lab1/Lab1_01_httpdTop.png)
##### 3. コマンドプロンプトで、 `[Ctrl]+c` を入力し、コンテナーを停止します。

## DockerコンテナーにホストOSのディスクのバインドとバッググラウンド起動
1. C:¥Handson¥Lab1のindex.htmlには、下記の内容が記述されています。このLab1ディレクトリーをhttpdコンテナーの、/usr/local/apache2/htdocsディレクトリーにバインドします。結果として、コンテナーの`http://localhost/`にアクセスすると、"Hello Apache!"の文字が表示されます。
    ```
    <html><body><h1>Hello Apache!</h1></body></html>
    ```
1. '-v (ホストPCのディレクトリー):(ゲストOSのディレクトリー)' オプションで、ゲストOSのディレクトリーに、ホストOSのディレクトリーをバインドできます。また '-d' オプションで、コンテナーをバックグラウンドで起動します。'docker run -p 20080:80 -v "$PWD":/usr/local/apache2/htdocs/ -d httpd' (Windowsの場合は、`docker run -p 20080:80 -v ${PWD}:/usr/local/apache2/htdocs/ -d httpd`) コマンドを入力します。今回は、ホストOSの20080番ポートに、コンテナーの80番ポートをマッピングしています。
    ```
    $ docker run -p 20080:80 -v "$PWD":/usr/local/apache2/htdocs/ -d httpd
    c6ee2bd00e8f3882a2a23605e4578e79e36b077eae6aaef5b15fe4a35559eb83
    $ 
    ```
1. ブラウザーで、`http://localhost:20080/` にアクセスします。'Hello Apache!'と表示され、ホストOSのディスクがコンテナーOSにバインドされたことが確認できます。
    
## DockerコンテナーのゲストOSへのログイン
1. '-d' オプションを付与して、httpdのコンテナーを起動していますので、バックグラウンドで、コンテナーが起動しています。`docker ps` コマンドで、現在稼働中のdockerコンテナーを表示できます。
    ```
    $ docker ps
    CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS                   NAMES
    99a58c8b3bba        httpd               "httpd-foreground"   18 seconds ago      Up 17 seconds       0.0.0.0:20080->80/tcp   inspiring_bassi
    $ 
    ```
1. `docker logs <CONTAINER ID>` で標準出力、標準エラー出力を表示することができます。
    ```
    $ docker logs 99a58c8b3bba
    AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 172.17.0.2. Set the 'ServerName' directive globally to suppress this message
    AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 172.17.0.2. Set the 'ServerName' directive globally to suppress this message
    [Sun Oct 28 10:45:14.202693 2018] [mpm_event:notice] [pid 1:tid 139755424806080] AH00489: Apache/2.4.37 (Unix) configured -- resuming normal operations
    [Sun Oct 28 10:45:14.202869 2018] [core:notice] [pid 1:tid 139755424806080] AH00094: Command line: 'httpd -D FOREGROUND'
    172.17.0.1 - - [28/Oct/2018:10:45:23 +0000] "GET / HTTP/1.1" 200 49
    172.17.0.1 - - [28/Oct/2018:10:45:23 +0000] "GET /favicon.ico HTTP/1.1" 404 209
    $ 
    ```
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


