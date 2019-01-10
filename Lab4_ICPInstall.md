
# Lab4. IBM Cloud Private の導入

このLabでは、IBM Cloud Private 環境を構築します。

前提

このLabでは、下記の準備を前提としています。
- Lab1 が終わっていること
  
所用時間は、およそ20分です。

----


## 1. IBM Cloud Private Cloud Native エディションの導入（製品版） 
  ※ Community版 で検証される方は、**2. IBM Cloud Private Community エディションの導入**へ。
  
1. 作業ディレクトリを作成します。
    ```
    # mkdir -p /work/lab4
    ```

1. SCPで /work/lab4 に IBMの導入パッケージ（ibm-cloud-private-x86_64-X.X.X.tar.gz)をアップロードします。
   製品イメージは、ICPライセンスをお持ちであれば、Passport Advantageのサイトからダウンロードすることが可能です。
    ```
    (作業PCから実行)
    $ scp ./ibm-cloud-private-x86_64-3.1.1.tar.gz root@hostname:/work/lab4
    ```
1. 作業ディレクトリに移動して、Docker導入パッケージに実行権限を付与します
    ```
    # cd /work/lab4
    # ls
    icp-docker-18.03.1_x86_64.bin
    # chmod +x icp-docker-18.03.1_x86_64.bin
    ``` 
1. Docker導入イメージを実行します
    ```
    root@icp01:/work/lab1# ./icp-docker-18.03.1_x86_64.bin --install
    Extracting docker.tar.gz
    Installing docker dependent package
    ```
1. `Docker --version`を実行して、正常に導入されたか確認します。
    ```
    root@icp01:/work/lab1# docker --version
    Docker version 18.03.1-ce, build 9ee9f40
    ```
  
## 2. Dockerイメージの導入（コミュニティ版）
[Docker CEドキュメント](https://docs.docker.com/install/linux/docker-ce/ubuntu/)に従い、Ubuntuを導入します。

1. aptレポジトリのアップデート
    ```
    # apt-get update
    Hit:1 http://mirrors.service.networklayer.com/ubuntu bionic InRelease
    Hit:2 http://mirrors.service.networklayer.com/ubuntu bionic-updates InRelease
    Hit:3 http://mirrors.service.networklayer.com/ubuntu bionic-backports InRelease
    Hit:4 http://mirrors.service.networklayer.com/ubuntu bionic-security InRelease
    Reading package lists... Done
    ```
1. 作業前提ファイル導入
    ```
    # apt-get install apt-transport-https ca-certificates curl software-properties-common
    ```
1. docker社のGPG鍵を apt-keyに登録
    ```
    # curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    OK
    ```
1. aptレポジトリの登録とレジストリの再アップデート
    ```
    # add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    Hit:1 http://mirrors.service.networklayer.com/ubuntu bionic InRelease
    Hit:2 http://mirrors.service.networklayer.com/ubuntu bionic-updates InRelease
    Hit:3 http://mirrors.service.networklayer.com/ubuntu bionic-backports InRelease
    Hit:4 http://mirrors.service.networklayer.com/ubuntu bionic-security InRelease
    Get:5 https://download.docker.com/linux/ubuntu bionic InRelease [64.4 kB]
    Get:6 https://download.docker.com/linux/ubuntu bionic/stable amd64 Packages [3695 B]
    Fetched 68.1 kB in 0s (141 kB/s)
    Reading package lists... Done
    ```
1. aptレポジトリの再アップデート
    ```
    # apt-get update 
    ```
1. 利用可能なdockerのパッケージ・バージョンを確認します。
    ```
    # apt-cache madison docker-ce
    docker-ce | 5:18.09.1~3-0~ubuntu-bionic | https://download.docker.com/linux/ubuntu bionic/stable amd64 Packages
    docker-ce | 5:18.09.0~3-0~ubuntu-bionic | https://download.docker.com/linux/ubuntu bionic/stable amd64 Packages
    docker-ce | 18.06.1~ce~3-0~ubuntu | https://download.docker.com/linux/ubuntu bionic/stable amd64 Packages
    docker-ce | 18.06.0~ce~3-0~ubuntu | https://download.docker.com/linux/ubuntu bionic/stable amd64 Packages
    docker-ce | 18.03.1~ce~3-0~ubuntu | https://download.docker.com/linux/ubuntu bionic/stable amd64 Packages
    ```
    [ICPがサポートするバージョンのDocker](https://www.ibm.com/support/knowledgecenter/ja/SSBS6K_3.1.0/supported_system_config/supported_docker.html)を確認してください。

1. ICPがサポートするDockerのバージョンを指定して、Dockerパッケージを導入します
    ```
    apt install  docker-ce=18.03.1~ce~3-0~ubuntu
    ``` 
1. `Docker --version`を実行して、正常に導入されたか確認します。
    ```
    root@icp01:/work/lab1# docker --version
    Docker version 18.03.1-ce, build 9ee9f40 
    ```
  
以上で、Lab1 は終了です。

