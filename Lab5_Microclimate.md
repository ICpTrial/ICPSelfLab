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
        )

## 新規Java プロジェクトの作成

1. 新規にJavaのマイクロサービス・プロジェクトを作成します。画面の下にある「新規プロジェクト」ボタンをクリックします。
下の画面には幾つかのプロジェクトがすでに存在しますが、最初はプロジェクトが存在しません。
![microclimate01](https://github.com/ICpTrial/ICPLab/blob/master/mcimage/microclimate01.png)
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
    ![microclimate08](https://github.com/ICpTrial/ICPLab/blob/master/mcimage/microclimate08.png)
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
![microclimate09](https://github.com/ICpTrial/ICPLab/blob/master/mcimage/microclimate09.png)
1. コンテナ・アプリケーション（Liberty）のログを確認するには、「アプリケーション・ログ」をクリックします。
![microclimate10](https://github.com/ICpTrial/ICPLab/blob/master/mcimage/microclimate10.png)
1. コンテナ・アプリケーション（Liberty）のリソースの利用状況を確認しながら、開発を実施することができます。<br>
「アプリケーション・モニター」をクリックします。
![microclimate11](https://github.com/ICpTrial/ICPLab/blob/master/mcimage/microclimate11.png)


## 作成された プロジェクトをGit に登録します。

ハンズオンで使用するレポジトリ<br>
  1人目　https://github.com/ICpTrial/lab501<br>
  2人目　https://github.com/ICpTrial/lab502<br>
  予備　 https://github.com/ICpTrial/lab503<br>
    
1. Terratermを利用して、ICPサーバーにログインします。このハンズオン環境は単体のK8S環境ですので、ローカル・ディレクトリにPersitentVolumeが構成されています。作成されたプロジェクトのroot ディレクトリにおいて、以下のコマンドを実行して、作成されたプロジェクトを Git レポジトリに登録します。<br>
`cd /work/microclimate/admin/labproject01`<br>
`git init`<br>
`git add .`<br>
`git remote add mygitrepos https://github.com/ICpTrial/labxxx` GitHubはそれぞれのものを利用してください<br> 
`git push --set-upstream mygitrepos master`

1. Git利用したGitHub を開いて登録されているかご確認ください。

## Jenkinsパイプラインとの関連付け
パイプラインの機能を利用して、このアプリケーションに、Jenkinsを利用したCI/CDの仕組みを関連付けます。
1. 一番下にある「パイプライン」を開き、「パイプラインの作成」をクリックします。
![pipeline01](https://github.com/ICpTrial/ICPLab/blob/master/mcimage/pipeline01.png)
1. パイプラインの名前および このアプリケーションが管理される GitレポジトリのURLを指定します。<br>

![pipeline02](https://github.com/ICpTrial/ICPLab/blob/master/mcimage/pipeline02.png)
1. 「資格情報の選択」をクリックし、このGitレポジトリにアクセスするための情報（ユーザーID&パスワードまたはTOKEN)を定義し、「パイプラインの作成」をクリックします。認証情報はハンズオン実施者に確認ください。
![pipeline03](https://github.com/ICpTrial/ICPLab/blob/master/mcimage/pipeline03.png)
1. 「デプロイメントの追加」をクリックし、ここでは、デフォルトのまま Master のブランチを追加します。
![pipeline06](https://github.com/ICpTrial/ICPLab/blob/master/mcimage/pipeline06.png)
1. パイプラインが作成されるので、パイプラインを開くをクリックします。
![pipeline04](https://github.com/ICpTrial/ICPLab/blob/master/mcimage/pipeline04.png)
1. このアプリケーションに関連付けられたJenkinsが開きます。
![pipeline07](https://github.com/ICpTrial/ICPLab/blob/master/mcimage/pipeline07.png)
1. masterパイプライン でのビルドおよびデプロイの状況を確認します。
![pipeline08](https://github.com/ICpTrial/ICPLab/blob/master/mcimage/pipeline08.png)


