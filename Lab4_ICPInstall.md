
# Lab4. IBM Cloud Private の導入

このLabでは、IBM Cloud Private 環境を構築します。

前提

このLabでは、下記の準備を前提としています。
- Lab1 が終わっていること
- ハンズオンは便宜上、すべてrootユーザーで実施します。


所用時間は、およそ60分（作業時間20分、待機時間40分）です。

----


## 1. IBM Cloud Private Cloud Native エディションの導入（製品版） 

[Knowledge Center: ICPのインストール](https://www.ibm.com/support/knowledgecenter/ja/SSBS6K_3.1.0/installing/install_containers.html)に従ってICPを導入します。
手順は簡略化していますので、導入でつまづいた場合にはこちらのリンクを確認してください。
  
1. 作業ディレクトリを作成します。
    ```
    # mkdir -p /work/lab4
    ```
1. インストーラーの実行に必要となる python を導入します
    ```
    # apt install python -y
    ```
1. SCPで /work/lab4 に IBMの導入パッケージ（ibm-cloud-private-x86_64-X.X.X.tar.gz)をアップロードします。
   製品イメージは、ICPライセンスをお持ちであれば、Passport Advantageのサイトからダウンロードすることが可能です。
    ```
    (作業PCから実行)
    $ scp ./ibm-cloud-private-x86_64-3.1.1.tar.gz root@hostname:/work/lab4/
    ```
1. 作業ディレクトリに移動し、ファイルを展開して dockerイメージをロードします（コマンドが抜けるまでに１０分ほどかかります）。
    ```
    # cd /work/lab4
    # ls
    ibm-cloud-private-x86_64-3.1.1.tar.gz
    # tar xf ibm-cloud-private-x86_64-3.1.1.tar.gz -O | sudo docker load
    8823818c4748: Loading layer    119MB/119MB
    19d043c86cbc: Loading layer  15.87kB/15.87kB
    883eafdbe580: Loading layer  14.85kB/14.85kB
    4775b2f378bb: Loading layer  5.632kB/5.63
    （中略）
    9100494ef1ef: Loading layer   7.68kB/7.68kB
    835a6678f29d: Loading layer  306.7kB/306.7kB
    182d4e3c01ad: Loading layer  262.2MB/262.2MB
    Loaded image: ibmcom/icp-kibana-amd64:5.5.1
    ``` 
1. ICP導入ディレクトリを作成し、移動します
    ```
    # mkdir /opt/icp3110
    # cd /opt/icp3110
    ```
1. ICP導入コンテナから、ICP構成テンプレートを抽出します。
    ```
    # docker run -v $(pwd):/data -e LICENSE=accept ibmcom/icp-inception-amd64:3.1.1-ee cp -r cluster /data
    # ls
    cluster
    # cd cluster/
    # ls
    config.yaml  hosts  misc  ssh_key
    ```
1. cluster ディレクトリの下に imagesディレクトリを作成し、元イメージを配置します。
    ```
    # pwd
    /opt/icp3110/cluster
    # mkdir images
    # mv /work/lab4/ibm-cloud-private-x86_64-3.1.1.tar.gz  images/
    ``` 
1. clusterディレクトリ配下の IBM Cloud Privateの構成ファイルを編集します。

    1. hostsファイルの編集
       このハンズオンではすべてのコンポーネントを１VM環境で構成するので、以下のように編集します。<br>
       インターフェースが Public LAN側と Private LAN側複数ある場合には、Private LAN側を指定します。<br>
       インターフェースが１つの環境では、そのIPアドレスを指定してください。この例では、IPアドレス 10.xxx.4.2 にICPのノード構成する例です。
       
        ```
        [master]
        10.xxx.4.2

        [worker]
        10.xxx.4.2

        [proxy]
        10.xxx.4.2

        #[management]
        #4.4.4.4

        #[va]
        #5.5.5.5
        ```
        今回の環境では、masterノード、workerノード、proxyノードすべてが 10.xxx.4.2 のVMに構成されます。
        また、managementノードが省略された場合には、関連コンポーネントは masterノードと同一のVMに構成されますので、10.xxx.4.2のVMに構成されます。
        通常の環境では、Knowledge Centerのガイド に従い適切に構成してください。
        
    1. config.yaml の編集<br>
        今回のハンズオンでは、以下に指定するものをのぞいて、全てデフォルト値のまま導入します。通常はきちんと設計して導入してください。
        
        1. 管理コンソール用 IPアドレスの設定
        通常は Privateネットワーク側のIPアドレスを指定しますが、ハンズオンでは便宜上 外部ネットワークからアクセスできるIPアドレスを指定します
        以下のエントリを探し、cluster_lb_address にIPアドレスを指定してください。
            ```
            ## External loadbalancer IP or domain
            ## Or floating IP in OpenStack environment
            # cluster_lb_address: none
            cluster_lb_address: <public ip address>
            ```
        1. Ingressプロキシー用 IPアドレスの設定
        こちらは外部ユーザーがアクセスされるIPアドレスので、外部ネットワークからアクセスできるIPアドレスを指定します
        以下のエントリを探し、cluster_lb_address にIPアドレスを指定してください。
            ```
            ## External loadbalancer IP or domain
            ## Or floating IP in OpenStack environment
            # proxy_lb_address: none
            proxy_lb_address: <public ip address>
            ```
        1. リソースに余裕がない環境では、このハンズオンでは使用しませんので、management_service のエントリを探し、以下のように metering と monitoring を無効化してください。
            ```
            management_services:
              istio: disabled
              vulnerability-advisor: disabled
              storage-glusterfs: disabled
              storage-minio: disabled
              metering: disabled      ##この行を追加
              monitoring: disabled    ##この行を追加
            ```
1. /etc/hosts で ICPの`hosts`ファイルに記載したIPアドレスがすべて逆引きできるように記載します。<br>
また 127.0.1.1のローカルホスト定義はコメントアウトします。

    ```
    127.0.0.1       localhost

    # The following lines are desirable for IPv6 capable hosts
    # ::1     ip6-localhost   ip6-loopback    ## ここをコメントアウト
    fe00::0 ip6-localnet
    ff00::0 ip6-mcastprefix
    ff02::1 ip6-allnodes
    ff02::2 ip6-allrouters
    ff02::3 ip6-allhosts
    #127.0.1.1      icp01.lab.com   icp01     ## ここをコメントアウト
    10.xxx.4.2      icp01.lab.com   icp01     ## ここを記載
    ```
    
1. SSHログインの構成

    1. SSH Key を生成し、clsuterディレクトリ配下に`ssh_key`の名前で配置します
        ```
        # ssh-keygen -b 4096 -f ~/.ssh/id_rsa -N ""
        # cp ~/.ssh/id_rsa /opt/icp3110/cluster/ssh_key
        ```
    1. この SSH Keyを使って、ICPの`hosts`ファイルに指定した IPアドレスに パスワードなしでログインできるよう構成します
      　SSHでパスワードなしログインできるようになればOKです。
        ```
        # ssh-copy-id -i ~/.ssh/id_rsa.pub root@<node_ip_address>
        /usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/root/.ssh/id_rsa.pub"
        /usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
        /usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
        root@10.xxx.4.2's password:

        Number of key(s) added: 1

        Now try logging into the machine, with:   "ssh 'root@10.xxx.4.2'"
        and check to make sure that only the key(s) you wanted were added.

        # ssh 10.xxx.4.2
        ・・・
        Last login: Thu Jan 10 13:50:58 2019 from 10.192.4.2
        root@icp01:~#
        root@icp01:~# exit       
        ```
    
1. clusterディレクトリで IBM Cloud Private 導入コンテナをキックし、インストーラーを実行します。`-vvv` オプションすることで、冗長なログ・メッセージを出力することができます。このIBM Cloud Privateの導入には ３０分ほどかかります。
    ```
    # cd /opt/icp3110/cluster
    # pwd
    /opt/icp3110/cluster
    # docker run --net=host -t -e LICENSE=accept -v "$(pwd)":/installer/cluster ibmcom/icp-inception-amd64:3.1.1-ee install
    PLAYBOOK: install.yaml *********************************************************
    24 plays in playbook/install.yaml

    PLAY [Checking Python interpreter] *********************************************
    （中略）
    
    
    
    # 
    ```

**注意** 導入時に Loopback アドレスが原因で導入が失敗する場合、[https://ibm.biz/icp-dnsfail](https://ibm.biz/icp-dnsfail)の手順に従ってください。Ubuntu 18.0.4 LTSでは発生するようです。

  ```
  fatal: [10.192.4.2]: FAILED! => changed=false
  msg: A loopback IP is used in your DNS server configuration. For more details, see https://ibm.biz/icp-dnsfail
  ```
1. config.yamlの以下の定義を見つけ `loopback_dns: true`を設定します。
    ```
    ## Allow loopback dns server in cluster nodes
    # loopback_dns: false
    loopback_dns: true
    ```

以上で Lab4 のハンズオンは終了です。Lab5 で実際にIBM CLoud Privateを触ってみます。
