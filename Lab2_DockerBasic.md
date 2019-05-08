# Lab2. Dockerの基本操作

このLabでは、Lab1 で作成した Ubuntu上のDocker環境で、Apache httpdのイメージを使用して、Dockerの基礎を学習します。

## 前提

このLabでは、下記の準備を前提としています。
- Ubuntu（またはその他Linux）環境が導入されその上に、docker-ceが導入されています。
- Ubuntuに SSHでログインして ハンズオンを実施します。

所用時間は、およそ20分です。

## Docker環境の確認

1. ハンズオン環境へのログイン

    1. ログインしていなければ、手元のPCのSSHクライアントを立ち上げ、ログインしてください。
    ```
    ssh root@dockermachine_ip
    ```

1. Docker環境の確認
    1. コマンドプロンプトで、 `docker version` コマンドを入力します。Dockerエンジンのバージョンが表示されます。
        ```
        root@icp11master:~# docker version
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
        # 
        ```

    1. 単に `docker` コマンドを入力することで、dockerコマンドのヘルプが、`docker COMMAND --help` と入力することで、`docker run` や `docker build` コマンドのヘルプを表示することができます。
    
    docker コマンドでできることを確認するには、以下のリンクを参考にしてください。<br>
[dockerドキュメント日本語化プロジェクト](http://docs.docker.jp/engine/reference/commandline/index.html)
    
## Apache httpdイメージのPull(ダウンロード)
1. `docker pull httpd` コマンドを入力し、Apache httpdの最新のDockerイメージを、ローカルPCのDockerレジストリーにダウンロードします。
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

    1. 今度はバックグラウンドで起動します。バックグラウンドで起動するには -d オプションを渡します。

    ```
    $ docker run -d -p 10080:80 httpd
    9ac73561ced434e100c33218e007404007d6a936c2077c80be98d4fc73f801e6
    ```
    1. 帰り値として、docker のコンテナーIDが返されます。`docker ps`で docker プロセスの状況を確認します。<br>
    ```
    $ docker ps | grep httpd
    9ac73561ced4        httpd                                            "httpd-foreground"       6 minutes ago       Up 5
    minutes       0.0.0.0:10080->80/tcp   hopeful_brattain
    ```

    1.　curl で httpdのコンテナーが稼働していることを確認します。
    ```
    $ curl http://localhost:10080/
    <html><body><h1>It works!</h1></body></html>
    ```
    
    1. `docker exec -it <コンテナID> /bin/bash` で、起動した コンテナにログインしてみます。
   
    コンテナIDには先ほどの docker ps で確認してコンテナIDを指定してください。前方一致で判断されますので、前方数桁を指定すればOKです。
    `hostname` や `cat htdocs/index.html` ログインしたコンテナで 叩いて見てください。
    ```
    # docker exec -it 9ac /bin/bash
    root@9ac73561ced4:/usr/local/apache2# hostname
    9ac73561ced4
    root@9ac73561ced4:/usr/local/apache2# ls htdocs
    index.html
    root@9ac73561ced4:/usr/local/apache2# cat htdocs/index.html
    <html><body><h1>It works!</h1></body></html>
    root@9ac73561ced4:/usr/local/apache2# exit
    ```
    
    1. `exit` してコンテナから抜けます。
    
## httpdのDockerコンテナーへのホストOSディスクのマウント

1. コンテナにディスク領域をマウントしてみます

    1. 今度は、コンテナに ローカル・ディスクの領域をマウントさせてみます。
    まず準備として、ローカルの `/work/contents` ディレクトリ配下に HTTPで表示するための `index.html` ファイルを作成します
    ```
    mkdir -p /work/lab1/contents
    echo "<html><body><h1>Local Contents</h1></body></html>" >> /work/lab1/contents/index.html
    ```

    1. 次に -v オプションで 作成したコンテンツをマウントさせて、起動します。
    なお、先ほどの10080 ポート はまだ使用されていますので、10081を指定しましょう。
    ```
    $ ~# docker run -d -p 10081:80 -v "/work/lab1/contents/:/usr/local/apache2/htdocs/" httpd
    69a5a4d63140d87cf39b1d41e8d01c3c8827de30fa7b8a3027634f8a509ba159
    ```

    1. 先ほど作成したコンテンツが 返されていることを確認します。<br>
    ```
    $ curl http://localhost:10081/
    <html><body><h1>Local Contents</h1></body></html>
    ```
    
    1. あらためて、docker ps で確認してコンテナIDを確認します。
    ```
    root@icp11master:~# docker ps | grep httpd
    69a5a4d63140        httpd                                            "httpd-foreground"       2 hours ago         Up 2 hours          0.0.0.0:10081->80/tcp   youthful_sammet
    9ac73561ced4        httpd                                            "httpd-foreground"       2 hours ago         Up 2 hours          0.0.0.0:10080->80/tcp   hopeful_brattain
    ```
    
    1. 先ほどと同じ要領で、10081番ポートでListen しているコンテナにログインしてみます。
        ```
        # docker exec -it 69a /bin/bash
        root@69a5a4d63140:/usr/local/apache2# hostname
        69a5a4d63140
        root@69a5a4d63140:/usr/local/apache2# ls htdocs
        index.html
        root@69a5a4d63140:/usr/local/apache2# cat htdocs/index.html
        <html><body><h1>Local Contents</h1></body></html>
        root@69a5a4d63140:/usr/local/apache2# mount | grep htdocs
        /dev/xvda2 on /usr/local/apache2/htdocs type ext4 (rw,relatime,data=ordered)
        ```
    1. `exit` してコンテナから抜けます。

## コンテナーのログの確認

1. コンテナーのログの確認を行います

    1. `docker logs <コンテナID>` で標準出力、標準エラー出力を表示することができます。

    ```
    $docker logs 69a
    AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 172.17.0.3. Set the 'ServerName' directive globally to suppress this message
    AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 172.17.0.3. Set the 'ServerName' directive globally to suppress this message
    [Fri Dec 21 04:55:24.154271 2018] [mpm_event:notice] [pid 1:tid 140667565786304] AH00489: Apache/2.4.37 (Unix) configured -- resuming normal operations
    [Fri Dec 21 04:55:24.154540 2018] [core:notice] [pid 1:tid 140667565786304] AH00094: Command line: 'httpd -D FOREGROUND'
    172.17.0.1 - - [21/Dec/2018:04:55:58 +0000] "GET / HTTP/1.1" 200 
    ```
    
    1. `docker logs -f  <コンテナID>` で標準出力、標準エラー出力を `tail -f` のように表示することもできます。
    
    ```
    root@icp11master:~# docker logs -f 69a
    AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 172.17.0.3. Set the 'ServerName' directive globally to suppress this message
    AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 172.17.0.3. Set the 'ServerName' directive globally to suppress this message
    [Fri Dec 21 04:55:24.154271 2018] [mpm_event:notice] [pid 1:tid 140667565786304] AH00489: Apache/2.4.37 (Unix) configured -- resuming normal operations
    [Fri Dec 21 04:55:24.154540 2018] [core:notice] [pid 1:tid 140667565786304] AH00094: Command line: 'httpd -D FOREGROUND'
    172.17.0.1 - - [21/Dec/2018:04:55:58 +0000] "GET / HTTP/1.1" 200 50
    ```

## コンテナーでのコマンドの実行


1. `docker exec` コマンドで、コンテナ上で任意のコマンドを実行してみます
    `docker exec` コマンドで、起動中のコンテナーOS上で、コマンドを実行することができます。
    
    1. `pwd` や `ls` 、`hostname`、`uname -a` コマンドなど、任意のコマンドを実行してみてください。
    
    1. 先ほどコンテナにログインした際のコマンド　`docker exec -it <CONTAINER ID> /bin/bash` は、指定されたコンテナで `/bin/bash` を実行しているイメージです。
    ```
    $ docker exec -it 99a58c8b3bba /bin/bash
    root@99a58c8b3bba:/usr/local/apache2# 
    ```
    
    1. コンテナOSは、通常 コンテナ実行に必要な最低限のライブラリに限定されていますので、必ずしもホストOS側で使っていたすべてのコマンドが使えるわけではありません。必要なライブラリがない場合は、コンテナをビルドする際に `apt`コマンドでパッケージを追加してください。
    ```
    docker exec -it 69a ifconfig
    OCI runtime exec failed: exec failed: container_linux.go:348: starting container process caused "exec: \"ifconfig\": executable file not found in $PATH": unknown
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
    
1. `docker ps -a` コマンドを入力することで、停止しているコンテナーも含めて、表示することができます。
    最初にフォアグラウンドで起動したコンテナと、バックグランドで起動した２つのコンテナの３つのコンテナが表示されます。

    ```
    $ root@icp11master:~# docker ps -a | grep httpd
    69a5a4d63140        httpd                                            "httpd-foreground"       2 hours ago         Exited (0) 2 seconds ago                       youthful_sammet
    9ac73561ced4        httpd                                            "httpd-foreground"       3 hours ago         Exited (0) 2 seconds ago                       hopeful_brattain
    dde28a828be8        httpd                                            "httpd-foreground"       3 hours ago         Exited (0) 3 hours ago                         hopeful_kowalevski
    $ 
    ```
    
1. コンテナ・インスタンスおよびコンテナ・イメージの削除
    停止したコンテナーを、再度、`docker start` コマンドで起動することもできますが、Dockerのコンテナーは、一度作成したコンテナーに変更を加えていくことは推奨されず、元のイメージから再度作り直すことがベストプラクティスです。
    今回のハンズオンでも停止したコンテナーを再度利用することはありませんので、`docker rm <CONTAINER ID>` コマンドで、停止しているコンテナーを削除します。<CONTAINER ID> は、複数のCONTAINER IDをリスト形式で並べて記述することも可能です。
    
    1. コンテナ・インスタンスの削除
    ```
    $ root@icp11master:~# docker rm 69a 9ac dde
    69a
    9ac
    dde
    ```
    1. `docker ps -a` コマンドで、停止中のコンテナーが存在しなくなったことを確認します。
    ```
    $ docker ps -a
    CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
    $
    ```
    
    1. コンテナ・イメージの削除
    
    今回のLabの最初に`docker pull`でダウンロードした、httpdのコンテナー・イメージを削除します。Dockerイメージの削除は、`docker rmi <Image_Name(:Tag)>` コマンドで削除します。<br>
`docker images` コマンドをあらためて実行し、httpdのDockerイメージの削除が行われたことを確認してください。
    
    
    ```
    root@icp11master:~# docker images | grep httpd
    httpd                                                                                                latest                         2a51bb06dc8b        5 weeks ago         132MB
    root@icp11master:~# docker rmi httpd
    Untagged: httpd:latest
    Untagged: httpd@sha256:9753aabc6b0b8cd0a39733ec13b7aad59e51069ce96d63c6617746272752738e
    Deleted: sha256:2a51bb06dc8baa17b4d78b7ca0d87f5aadbd98d711817dbbf2cfe49211556c30
    Deleted: sha256:408e085f6e7843c5a45cf000adaa182983775286810e864e3c4037a50d0859a0
    Deleted: sha256:84fc70d81e4ad5fe0f19a0f9fe0f7a2162187e0e161524918694933db2f0e5a9
    Deleted: sha256:546124d5bbb37443470d64da7f65bfa56f31f06eb848ce6da2aa1ba5830d9ae2
    Deleted: sha256:1beaafb12fe6f5202e84a03b74b205052b9b54bbfc1ddd39e389c2eb9c52d583
    Deleted: sha256:ef68f6734aa485edf13a8509fe60e4272428deaf63f446a441b79d47fc5d17d3
    root@icp11master:~# docker images | grep httpd
    ```

以上で、Lab2 は終了です。

引き続き、Lab3では Dockerfile を利用して、オリジナルのコンテナー・イメージをビルドしていきます。
