
# Lab1. Dockerの導入

このLabでは、IBM Cloud Private (Kuberentes)の前提となる Docker環境を構築します。

前提

このLabでは、下記の準備を前提としています。
 - 任意のクラウドまたは仮想環境上に Ubuntu環境が導入されています。
 　Ubunut環境のリソースは、あとでICP導入のため 8vCPU 16GB Memory 100GB Storageを想定します
  （ハンズオンを限られたリソースで実施できるよう製品の公式なSystem Requirementは満たしていません）<br>
  参考 [Knowledge Center: ICPのシステム要件](https://www.ibm.com/support/knowledgecenter/ja/SSBS6K_3.1.0/supported_system_config/system_reqs.html)
 - UbuntuにSSHでログイン可能
 - Ubuntu環境からパブリックのインターネット経由で諸々のダウンロードが可能
 - ハンズオンは便宜上すべてrootで行います
 
所用時間は、およそ20分です。

----


## 1. Docker イメージの導入（製品版） 
  ※ Community版 で検証されている方は、**2. Dockerイメージの導入（コミュニティ版）**へ。
  
1. 作業ディレクトリを作成します。
    ```
    # mkdir -p /work/lab1
    ```

1. SCPで /work/lab1 に 製品提供の Docker導入パッケージ（icp-docker-xx.xx.x_x86_64.bin)をアップロードします。
Docker導入パッケージは、ICPライセンスをお持ちであれば、ICP本体と同様Passport Advantageのサイトからダウンロードすることが可能です。
    ```
    (作業PCから実行)
    $ scp ./icp-docker-18.03.1_x86_64.bin root@hostname:/work/lab1
    ```
1. 作業ディレクトリに移動して、Docker導入パッケージに実行権限を付与します
    ```
    # cd /work/lab1
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
以上で、Lab1 は終了です。  
  
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
1．Dockerのバージョンをホールドします。
    ```
    apt-mark hold docker-ce
    ```

以上で、Lab1 は終了です。
