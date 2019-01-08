# Lab3. ICPコンソールからサンプルのLiberty Helmチャートのデプロイ

このLabでは、IBM提供のサンプルのWebSphere LibertyのHelmチャートを使用して、ICP上にLibertyのPodなどをデプロイし、Kubernetesの構成物(オブジェクト)を確認します。

## 前提

このLabでは、下記の準備を前提としています。
- インターネットに接続できるICP
- ICPコンソールにアクセスできるPC

所用時間は、およそ20分です。

## ICPコンソールへのアクセス

1. ブラウザーで、`https://(ICP MasterノードのIP):8443/`にアクセスします。ICPコンソールのログイン画面が表示されます。<br>
    SSLの自己署名証明書の警告が表示される場合には、危険性を理解してアクセスするを選択してください。<br>
    ![consoleLogin](https://github.com/ICpTrial/ICPLab/blob/master/images/Lab3/Lab3_01_consoleLogin.png)
    
1. ユーザー名とパスワードを入力して、ログインします。
1. ようこそ画面が表示されます。左上のメニューボタンをクリックすることで、ナビゲーション・メニューが左側に表示されます。<br>
    ![consoleMenu](https://github.com/ICpTrial/ICPLab/blob/master/images/Lab3/Lab3_02_consoleMenu.png)

## 名前空間の定義
ICP/Kubernetesのクラスターでは、Kubernetesのオブジェクトを名前空間で分離されます。デフォルトで、default名前空間が定義されていますが、今回のハンズオン用にhandson名前空間を定義します。各プロジェクトごとや、開発環境とテスト環境などで、名前空間を分離することもできます。
1. ナビゲーション・メニューから、[管理]>[名前空間]を選択します。
1. 右上の[名前空間の作成]ボタンをクリックします。<br>
    ![createNS](https://github.com/ICpTrial/ICPLab/blob/master/images/Lab3/Lab3_03_createNS.png)
1. 名前欄に "handson"と入力し、PodSecurityPolicy に ibm-anyuid-hostacess-psp を指定して、[作成]ボタンをクリックします。
　　<br>Pod Security Policy に関しては、最後の講義で触れます。
1. 名前空間の一覧ページに「handson」名前空間が追加されたことを確認します。<br>
    ![createNSresult](https://github.com/ICpTrial/ICPLab/blob/master/images/Lab3/Lab3_04_createNSresult.png)

## IBM提供Helmチャートを用いたLibertyのデプロイ
IBM提供のLibertyのHelmチャートを用いて、Libertyアプリケーションに関連するKubernetesの構成物をまとめてデプロイできます。デプロイされた一連の構成物をHelmリリースと呼びます。
1. コンソール上部のメニューから、[カタログ]を選択します。Helmチャートの一覧が表示されます。<br>
    ![HelmCatalog](https://github.com/ICpTrial/ICPLab/blob/master/images/Lab3/Lab3_05_HelmCatalog.png)
1. 上部の検索入力領域に「liberty」と入力します。[ibm-websphere-liberty]のHelmチャートを選択(クリック)します。<br>
    ![LibertyHelm](https://github.com/ICpTrial/ICPLab/blob/master/images/Lab3/Lab3_06_LibertyHelm.png)
1. Liberty Helmチャートの概要が表示されます。<br>
    LibertyのHelmチャートのデプロイのパラメーターの説明などが表示されます。今回は、1つデプロイしてみることが目的ですので、画面右下の[構成]ボタンをクリックします。<br>
    ![LibertyHelmOverview](https://github.com/ICpTrial/ICPLab/blob/master/images/Lab3/Lab3_07_LibertyHelmOverview.png)
1. Helmチャートのデプロイに必須のパラメーターが画面上部に、オプションのパラメーターが省略された形で表示されます。<br>
    必須入力項目に、下記のパラメーターを入力します。
    - Helm リリース名: liberty-default-helm
    - ターゲット名前空間: handson
    - ライセンス (チェックボックス): ON
    ![LibertyHelmConfig1](https://github.com/ICpTrial/ICPLab/blob/master/images/Lab3/Lab3_08_LibertyHelmConfig1.png)
1. 「> すべてのパラメーター」の部分をクリックし、省略されたパラメーターを展開します。
1. 以降のLabで、別のLibertyアプリケーションをデプロイするときの参考にするため、「Ingress settings」の項目を下記のように、入力します。
    - Enable ingress (チェックボックス): ON
    - Path: /test1
    ![LibertyHelmConfig2](https://github.com/ICpTrial/ICPLab/blob/master/images/Lab3/Lab3_09_LibertyConfig2.png)
1. 他の項目はデフォルトのまま、右下の[インストール]ボタンをクリックします。
1. 下記のポップアップ・ウィンドウが表示されますので、[Helm リリースの表示]ボタンをクリックします。
![HelmReleasePopup](https://github.com/ICpTrial/ICPLab/blob/master/images/Lab3/Lab3_10_HelmReleasePopup.png)
1. デプロイしたliberty-default-helmリリースの概要と、画面をスクロールすることで、このhelmリリースに関連するKubernetesのオブジェクト(デプロイメント、Ingress、ポッド、サービスなど)が表示されます。また、それぞれのハイパーリンクをクリックすることで、それぞれのオブジェクトの詳細を確認することもできます。(尚、他のオブジェクトを表示したのち、このページに戻るには、ナビゲーション・メニューから、[ワークロード]>[Helm リリース]を選択し、一覧から「liberty-default-helm」を選択します。)<br>
    - ポッドは、Libertyのコンテナーが稼働する最小のインスタンスです。今回は、1インスタンスで作成していますが、同一のポッドを2つ、3つと起動することができます。
    - デプロイメントは、同一の複数のポッドをまとめて管理するオブジェクトです。耐障害性や更新時のポッドの起動停止を制御します。
    - サービスは、同一の複数のポッドへの通信アクセスの割り振り制御を行います。ClusterIPとNodePortの2種類のタイプがあり、ClusterIPは、Kubernetesのクラスター内部の通信で使用できます。例えば、同一のクラスター内で管理されるLibertyとDBとの通信などで利用できます。NodePortは、Kubernetesのクラスター外部からの通信で使用することができます。例えば、自身のPCのブラウザーから、LibertyのWebアプリケーションへの通信で利用できます。Kubernetesのノードのポート(30000番台)をクラスターIPにマッピングします。NodePortを作成すると、自動的にClusterIPも作成されます。
    - Ingressも、NodePortと同様に、Kubernetes外部からの通信で使用します。ICPのProxyサーバー経由で通信が行われ、L7での負荷分散が行われます。
![HelmReleaseAll](https://github.com/ICpTrial/ICPLab/blob/master/images/Lab3/Lab3_11_LibertyHelmRelaseAll.png)

## デプロイしたLibertyへのアクセスの確認
1. アプリケーションにアクセスしてみます。まずは、NodePort経由でアクセスします。<br>
    「サービス」の項目のポートの欄の「9443」とマッピングされている30000番台のポート番号を確認します。下記の例は、「31114」ですが、リリース時にランダムに割り振られます。
    ![NodePortDef](https://github.com/ICpTrial/ICPLab/blob/master/images/Lab3/Lab3_12_NodePortDef.png)
1. 上記のポート番号を使用して、ブラウザーで`https://(ICPのIPアドレス):(30000番台のポート)/`にアクセスします。ICPコンソールとは、別のタブを開いて、アクセスしてください。(自己署名証明書の警告が表示される場合は、認めてください)。Libertyのデフォルト・コンテキストルートのページが表示されます。
![NodePortAccess](https://github.com/ICpTrial/ICPLab/blob/master/images/Lab3/Lab3_13_NodePortAccess.png)
1. 次に、Ingress経由でアクセスします。<br>
    ブラウザーで新しいタブを開き、`https://(ICPのIPアドレス)/test1/` にアクセスします。NodePort経由でアクセスした場合と同様の、Libertyのデフォルト・コンテキストルートのページが表示されます。今回は、ICPは1台のサーバーですべての役割が稼働していますが、役割ごとにノードを分離している場合には、ProxyノードのIPアドレス(/ホスト名)を指定します。`test1` は、Helmチャートのデプロイ時にオプションのIngress settingsで設定したPathのパラメーターの値です。

以上で、Lab3は終了です。引き続き、Lab2で、作成したDockerイメージを、ICPのKubernetes環境にデプロイします。



