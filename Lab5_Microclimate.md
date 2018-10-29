# Lab5. ICP上での Mircroclimate の実行

このLabでは、ICP上で Microclimate を実行して、新規Java マイクロサービス・アプリケーションを開発していく手順を確認します。

## 前提

この　Labでは、下記の準備を前提としています。
- ICP上に Microclimate をすでに導入しています。このツールは、ICP環境を導入したあとで、helmカタログから導入・構成する必要があります。
- インターネットに接続できる環境

所用時間は、およそ30分です。

## Microclimate 環境の確認

1. ICP環境にログオンし、Microclimate を開きます。
    1. ブラウザで指定されたインスタンスの ICP環境のコンソールを開きます。<br>
        https://microclimate.<ICP_Proxy_Adress>.nip.io 
        認証情報　admin : admin<br>  ※ログインしていない場合は、ICPの認証情報でログインしてください。
        ![microclimate01](https://github.com/ICpTrial/ICPLab/blob/master/mcimage/microclimate01.png)

## 新規Java プロジェクトの作成

1. 新規にJavaのマイクロサービス・プロジェクトを作成します。画面の下にある「新規プロジェクト」ボタンをクリックします。
 ![microclimate02](https://github.com/ICpTrial/ICPLab/blob/master/mcimage/microclimate02.png)
1. 作成するプロジェクトの言語として「Java」を選択し、プロジェクト名 「labproject01」を指定します。
 ![microclimate03](https://github.com/ICpTrial/ICPLab/blob/master/mcimage/microclimate03.png)
1. Javaアプリケーションのフレームワークを選択します。ここでは、「Microprofile/JavaEE」を指定します。
 ![microclimate04](https://github.com/ICpTrial/ICPLab/blob/master/mcimage/microclimate04.png)
1. Javaアプリケーションのコンテキストルートを指定します。デフォルトではプロジェクト名が入ります。ここではそのままにし、「作成」をクリックします。
 ![microclimate05](https://github.com/ICpTrial/ICPLab/blob/master/mcimage/microclimate05.png)
1. 以下のようなプロジェクトが作成され、自動生成されたアプリケーションをベースにアプリケーションおよびコンテナのビルドが走ります。
　 しばらくお待ち下さい。
 ![microclimate06](https://github.com/ICpTrial/ICPLab/blob/master/mcimage/microclimate06.png)
 
## 作成された プロジェクトの確認
1. 自動生成されたプロジェクトを確認していきます。「コードの編集」を開きます。
 ![microclimate07](https://github.com/ICpTrial/ICPLab/blob/master/mcimage/microclimate07.png)
  1. src配下に 自動生成された非常にシンプルなアプリケーションが配置されています。<br>
  これは、REST API で GETで呼ばれた場合に、メッセージを返すのみのシンプルなものです。
  1. またアプリケーションには、Microprofileで定められた アプリケーションの正常性を確認するための HealthEndpoint.java も定義されています。
  1. アプリケーションの下には、Libety の構成ファイル (liberty¥config）が生成されています。<br>
  本体である server.xml や、環境変数を設定するための server.env、jvm引数として渡すための jvm.options などのファイルがあります。
  1. webapp の下には、WEB-INF下に配置される各種定義ファイルが配置されています。
  1. その他、アプリケーションのルートディレクトリには、コンテナをビルドするための Dockerfile が定義されています。<br>
  このファイルを使って、コンテナのビルドが行われます。
  1. Readme.md は、GitHubにこのアプリケーションが登録された際に、ReadMeとして表示される MarkupDocument です。<br>
  お客様環境に適宜あわせて利用します。
1. コンテナーのビルドのログを確認するには、「ビルド・ログ」をクリックします。
1. 実際のアプリケーションが稼働しているか確認するには、「アプリケーションを開く」をクリックします。
1. 


