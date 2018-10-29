
# Lab3. ICP上でのTransformation Advisor の実行

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

    1. コンソール真ん中の「Add a new workspace」をクリックします。
    1. 「1 / 2　Name a new workspace to begin」で 任意のワークスペース名を付けます。ここでは「workspace01」とします　。
    1. 「2 / 2　Create a collection to assign to your workspace」で、集めた情報を収集しておくコレクションの最初のコレクションの名前を付けます。ここでは「collection01」とします。一つのワークスペースの配下に任意の数のコレクションを作成していくことが可能です。システム単位でコレクションを作成するなどがいいかもしれません。
    
 ## Transformation Advisor 解析の実施   
  
1. エージェントをしかけて、既存のWebSphereアプリケーションの解析を実施します。
1. コンソール中央の「DataColletor」のボタンをクリックします。
1. 既存WebSphereが稼働する環境に応じて、ダウンロードするエージェントを確認します。
　　ここでは、「Linux」環境で稼働する「WebSphere」アプリケーション・サーバーを、「App&Configuration（アプリケーションおよび構成）」含めて解析を実施することします。
1. 「Download for Linux」のボタンをクリックして、TransformationAdvisorのエージェントをダウンロードします。 
1. 現行アプリケーション・サーバー環境での解析を実施します。
    1. 実際の環境では、ダウンロードしたエージェントを、現行のアプリケーションが稼働する環境の任意のディレクトリ（/workや/tmpなど）に SCPなどで転送して配置します。
    1. 転送したきたエージェントのファイルを以下のコマンドで解凍します。
    * tar xvfz transformationadvisor-2.1_Linux_collection01.tgz

    1. 解凍されたアプリケーションの transformationAdvisor ディレクトリに移動します。
    * cd transformationadvisor-2.1
    1. binディレクトリ配下にある transoformationAdvisorを実行します。
    * ./bin/transformationadvisor -w <WEBSPHERE_HOME_DIR> -p <PROFILE_NAME> <WSADMIN_USER> <WSADMIN_PASSWORD>
        ここで <WEBSPHERE_HOME_DIR> は /opt/IBM/WebSphere ディレクトリ、<PROFILE_NAME> は、WASのプロファイル名 例えば Dmgr01 です。
        <WSADMIN_USER> <WSADMIN_PASSWORD> には、当該環境に適切なWAS管理ユーザー（wasadmin など）と、パスワードを指定してください。
    1. 正常に実行されると、zipファイルが生成されます。
    
    
        <WSADMIN_USER> <WSADMIN_PASSWORD> には、当該環境に適切なWAS管理ユーザー（wasadmin など）と、パスワードを指定してください1
        <WSADMIN_USER> <WSADMIN_PASSWORD> には、当該環境に適切なWAS管理ユーザー（wasadmin など）と、パスワードを指定してください。.
        <WSADMIN_USER> <WSADMIN_PASSWORD> には、当該環境に適切なWAS管理ユーザー（wasadmin など）と、パスワードを指定してください。 
        <WSADMIN_USER> <WSADMIN_PASSWORD> には、当該環境に適切なWAS管理ユーザー（wasadmin など）と、パスワードを指定してください。
 ## Transformation Advisor 解析結果の確認            
  
    
