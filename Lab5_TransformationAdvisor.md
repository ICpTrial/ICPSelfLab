
# Lab5. ICP上でのTransformation Advisor の実行

このLabでは、ICP上で Transformation Advisor を実行して、既存JavaEEアプリケーションをモダナイズのためのツールを活用する手順を確認します。

## 前提

この　Labでは、下記の準備を前提としています。
- ICP上に Transformation Advisor をすでに導入しています。
　実際には、ICP環境を導入したあとで、helmカタログから Transformation Advisor を追加で導入・構成する必要があります。
- インターネットに接続できる環境

所用時間は、およそ30分です。

## Transformation Advisor 環境の確認

1. ICP環境にログオンし、トランスフォーメーション・アドバイザーを開きます。
    1. ブラウザで指定されたインスタンスの ICP環境のコンソールを開きます。
        https://<ICP_ClusterIP:8443/icp/console 
        認証情報　admin : admin

    1. ICPのメニューを開き、Tools > Transformation を開きます。
    　　※ Transformation Advisorを構成されていないICP環境ではメニューが含まれていません。
　　　　　 Transformation Advisorを導入すると、メニューが表示されるようになります。

## Transformation Advisor ワークスペースの作成

1. 解析のための作業スペースとなる ワークスペースを作成します。
![toppage] (https://github.com/ICpTrial/ICPLab/tree/master/trfadvimage/transformationadvisortop.png)
    1. コンソール真ん中の「Add a new workspace」をクリックします。
    1. 「1 / 2　Name a new workspace to begin」で 任意のワークスペース名を付けます。ここでは「workspace01」とします　。
    1. 「2 / 2　Create a collection to assign to your workspace」で、集めた情報を収集しておくコレクションの最初のコレクションの名前を付けます。ここでは「collection01」とします。一つのワークスペースの配下に任意の数のコレクションを作成していくことが可能です。システム単位でコレクションを作成するなどがいいかもしれません。
    
 ## Transformation Advisor 解析の実施
  
1. エージェントをしかけて、既存のWebSphereアプリケーションの解析を実施していきますます。

1. コンソール中央の「DataColletor」のボタンをクリックします。
 ![analyze01](https://github.com/ICpTrial/ICPLab/tree/master/trfadvimage/analyze01.png)
1. 既存WebSphereが稼働する環境に応じて、ダウンロードするエージェントを確認します。
　　ここでは、「Linux」環境で稼働する「WebSphere」アプリケーション・サーバーを、「App&Configuration（アプリケーションおよび構成）」含めて解析を実施することします。
 ![analyze02](https://github.com/ICpTrial/ICPLab/tree/master/trfadvimage/analyze01.png)
1. 「Download for Linux」のボタンをクリックして、TransformationAdvisorのエージェントをダウンロードします。 
1. 現行アプリケーション・サーバー環境での解析を実施します。
　　注）このハンズオンでは、便宜上、すでに実行された結果のハンズオンをあとで使用しますので、ここでは手順だけ確認します。
    1. 実際の環境では、ダウンロードしたエージェントを、現行のアプリケーションが稼働する環境の任意のディレクトリ（/workや/tmpなど）に SCPなどで転送して配置します。
    1. 転送したきたエージェントのファイルを以下のコマンドで解凍します。
    `tar xvfz transformationadvisor-2.1_Linux_collection01.tgz`

    1. 解凍されたアプリケーションの transformationAdvisor ディレクトリに移動します。
    `cd transformationadvisor-2.1`
    1. binディレクトリ配下にある transoformationAdvisorを実行します。
    `./bin/transformationadvisor -w <WEBSPHERE_HOME_DIR> -p <PROFILE_NAME> <WSADMIN_USER> <WSADMIN_PASSWORD>`
        ここで <WEBSPHERE_HOME_DIR> は /opt/IBM/WebSphere ディレクトリ、<PROFILE_NAME> は、WASのプロファイル名 例えば Dmgr01 です。
        <WSADMIN_USER> <WSADMIN_PASSWORD> には、当該環境に適切なWAS管理ユーザー（wasadmin など）と、パスワードを指定してください。
    1. 正常に実行されると、zipファイルが生成されます。

 ## Transformation Advisor 解析結果の確認
 
 1. エージェントの実行結果が以下のリンクに配置されていますので、ローカルのPCにダウンロードします。
 1. コンソールの中央にある「Upload Data」を選択し、クリックします。
 1. クリックして開いた画面の「Drop or Add File」を選択し、先にダウンロードした実行結果ファイル `DefaultAppSrv01.zip` を指定します。
 1. レポート結果が開きますので確認していきます。

    1. 収集してきたアプリケーションのプロファイル名が表示され、移行先のターゲットとして「Liberty on Private Cloud」が設定されています。
    1. このプロファイルには、アプリケーションが２つ（CustomOrderServiceApp.earとquery.ear）が含まれていることがわかります。
    　　それぞれ、アプリケーション移行の複雑さは、<Moderate> （通常レベル）として判断されています。
    　　この中で、移行に関する課題Issueがそれぞれ、幾つか上がっています。
    　　ここでは CustomOrderServiceApp.ear を展開して、詳細を確認していきます。
    
 1. CustomOrderServiceApp.earをクリックして開きます。
    1. 上部にはアプリケーションの概要や、アプリケーションの変更を行う場合の工数の目安が記載されています（ただしこれはあくまでツールから外から考えられる数字ですので、お客様の実態にあわせて考える必要があります。あくまで目安とお考えください。）
    1. テクニカル・イシューとして１つ重要レベルの課題があがっており、「Behavior change on lookups for Enterprise JavaBeans」が上げられています。
    　　これは赤印がついていますので、マイグレーションの際に実際に対応しないといけない課題です。

 1. テクニカルな稼働を確認するために「Analytics Report」を確認します。先ほどの解析のなかで Issuseとして上がっている内容の詳細を確認できます。
    1. 「Detailed Results by Rule」に先ほど確認した課題のリストの詳細があります。
    1. 「Behavior change on lookups for Enterprise JavaBeans」の show result を開いて、どのファイルに問題があるか確認します。showrule help を開くと、どのような課題なのかを確認することができ、場合によっては修正の仕方のガイドがあります。
    1. その他の結果についても同様に確認してくださいｓ．
    
 1. 「Technical Report」を確認します。これはアプリケーションで利用されているAPIのリストが表示されます。
 　　様々なアプリケーション・サーバー環境がリストされていますが、チェックが入っていない環境では当該のAPIが稼働しません。
   　そのテクノロジーの移行を考えるか、移行先をサポートされるものの中から選ぶかを実施する必要があります。
    
 1. 「Inventory Report」は、当該のアプリケーションの構造を示してくれます。保守するメンバーがいなくなってしまった場合などに、アプリケーションの作りの概要を理解するのに役立ちます。
      
  
 ## Migration Planの作成
 
 ツールが作成してくれた構成ファイルを利用して、マイグレーションを検討していきます。Recommendationの画面から「Migration Plan」のボタンをクリックします。
 
 1. ボタンを開くと、当該アプリケーションをコンテナ化するための様々な構成ファイルがリストされます。
 1. Application Bundle をクリックして、当該のアプリケーションを関連付けます。
 1. アプリケーションまで関連付けると、GitHubのサービス および ICP上の CI/CDのための環境 Microclimate まで関連づけていくことが可能です。
    右の「Application Bundle」を選択します。
    1. 別途 GitHub 上に作成したプロジェクトのURLを指定します。認証情報も USERID/PASSWORD または TOKEN で指定してください。
    1. ICP上のMicroclimate の URLを指定します。
    1. 「Deploy」をクリックします。一連の生成されたコードとアプリケーションがGitHub上に登録され、そこから Mircoclimate のプロジェクトが生成されます。
 
 　
 
 
 
  
    
