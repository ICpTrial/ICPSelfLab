
# Lab9. ICP上でのTransformation Advisor の実行

このLabでは、ICP上で Transformation Advisor を実行して、既存JavaEEアプリケーションをモダナイズのためのツールを活用する手順を確認します。

## 前提

この Labでは、下記の準備を前提としています。

- ICP Transformation Advisor は、製品版の IBM Cloud Privateで提供されている機能です。
- インターネットに接続できる環境
- ICP環境に用意されているリソースが 8Core/16GB の場合には、快適に操作ができない可能性があります。必要に応じてリソースを増強ください。

所用時間は、およそ40分です。


## Transformastion Advisor の導入

1. ICP環境にログオンします。
    1. ブラウザで指定されたインスタンスの ICP環境のコンソールを開きます。<br>
        https://<ICP_ClusterIP:8443/icp/console<br> 
        認証情報　admin : admin<br>
    1. 右上のメニューから「カタログ」を選択し、ICPのソリューション・カタログのページを開きます
    1. カタログの画面で検索バーに「transadv」を入力し、絞り込まれた「ibm-transadv-dev」のアイコンをクリックし、Transformation Advisor のHELMチャートを開きます。
    
1. 「IBM CLOUD TRANSFORMATION ADVISOR」のチャートに表示されている README を確認し、導入手順を確認します。導入手順は、HELMのリリースが上がった場合に追加のステップが必要となる可能性があります。ここでは、執筆時点の最新である v1.9.1 をもとに 導入手順を記載します。
    1. この手順では `default` 名前空間に払い出しを行います
    1. Transformation Advisor の 認証情報を、Kubernetes 上に Secret として 作成します。
        1. 以下の内容をコピーし、 transadvsecret.yaml という名前で、/work/lab9 ディレクトリに保管します。
        ```
        apiVersion: v1
        kind: Secret
        metadata:
            name: transadvsecret
        data:
            db_username: YWRtaW4=
            secret: dGhpcy13aWxsLWJlLW15LXNlY3JldC13aXRob3V0LXNwYWNl
        ```
        なお、db_username および secret は、HELM chartの READMEに記載されているように、それぞれ "admin"と"this-will-be-my-secret-without-space"を base64でエンコードしたものです。必要に応じて、適切なパスワードに変更ください。
            
         1. 以下のコマンドで、Secret を作成します
        ```
        # kubectl apply -f /work/lab9/transadvsecret.yaml  -n default
        ```
        
         1. 以下のコマンドで、Secret が作成されていることを確認してください。
        ```
        # kubectl get secrets -n default
        ```
    1. ICP GUIコンソール上の、Transformation Advisor の HELMチャートに戻り「構成」のボタンをクリックします。以下を指定します。
         
         **構成**
         * HELMリリース名： transadv
         * ターゲット名前空間： default
         * 使用許諾条件： チェックを入れる
         
         **パラメータ**
         * Edge node IP： <ICPサーバーのIPアドレス>
         * Secret Name：transadvsecret　　　## 一つ前の手順で作成したSecretの名前
         
         **すべてのパラメータ**
         * Enable persistence for this deployment： チェックを外す
         * Use dynamic provisioning for persistent volume： チェックを外す
         デフォルトでは、Persistence Volume に、Transformation Advisorの結果などを保管する設定となっています。ハンズオンではこの永続化設定は外しておきます。
    1. 「インストール」ボタンをクリックします。HELMの導入が始まります。
    1. HELMインスタンスのページに移動し、４つの Deployment すべてが `利用可能` になっていることを確認します。
    
    これで、`Transformation Advisor` の導入は完了です。

## Transformation Advisor 環境の確認

    1. ICPのメニューを開き、Tools > Transformation を開きます。<br>
    ※ Transformation Advisorを構成されていないICP環境ではメニューが含まれていません。<br>
      Transformation Advisorを導入すると、メニューが表示されるようになります。

## Transformation Advisor ワークスペースの作成

1. 解析のための作業スペースとなる ワークスペースを作成します。<br>
![toppage](https://github.com/ICpTrial/ICPLab/blob/master/trfadvimage/transformationadvisortop.png)
    1. コンソール真ん中の「Add a new workspace」をクリックします。
    1. 「1 / 2　Name a new workspace to begin」で 任意のワークスペース名を付けます。ここでは「workspace01」とします　。
    1. 「2 / 2　Create a collection to assign to your workspace」で、集めた情報を収集しておくコレクションの最初のコレクションの名前を付けます。ここでは「collection01」とします。一つのワークスペースの配下に任意の数のコレクションを作成していくことが可能です。システム単位でコレクションを作成するなどがいいかもしれません。
    
 ## Transformation Advisor エージェントの実行
  
1. エージェントをしかけて、既存のWebSphereアプリケーションの解析を実施していきますます。

1. コンソール中央の「DataColletor」のボタンをクリックします。
 ![analyze01](https://github.com/ICpTrial/ICPLab/blob/master/trfadvimage/analyze01.png)
1. 既存WebSphereが稼働する環境に応じて、ダウンロードするエージェントを確認します。<br>
ここでは、「Linux」環境で稼働する「WebSphere」アプリケーション・サーバーを、「App&Configuration（アプリケーションおよび構成）」含めて解析を実施することします。
 ![analyze02](https://github.com/ICpTrial/ICPLab/blob/master/trfadvimage/analyze02.png)
1. 「Download for Linux」のボタンをクリックして、TransformationAdvisorのエージェントをダウンロードします。 
1. 現行アプリケーション・サーバー環境でエージェントを実行します。<br>
注）このハンズオンでは、便宜上、すでに実行された結果のハンズオンをあとで使用しますので、ここでは手順だけ確認します。<br>
    1. 実際の環境では、ダウンロードしたエージェントを、現行のアプリケーションが稼働する環境の任意のディレクトリ（/workや/tmpなど）に SCPなどで転送して配置します。
    1. 転送したきたエージェントのファイルを以下のコマンドで解凍します。<br>
    `tar xvfz transformationadvisor-2.1_Linux_collection01.tgz`<br>
    1. 解凍されたアプリケーションの transformationAdvisor ディレクトリに移動します。<br>
    `cd transformationadvisor-2.1`<br>
    1. binディレクトリ配下にある transoformationAdvisorを実行します。<br>
    `./bin/transformationadvisor -w <WEBSPHERE_HOME_DIR> -p <PROFILE_NAME> <WSADMIN_USER> <WSADMIN_PASSWORD>`<br>
    ここで <WEBSPHERE_HOME_DIR> は /opt/IBM/WebSphere ディレクトリ、<PROFILE_NAME> は、WASのプロファイル名 例えば Dmgr01 です。<br>
    <WSADMIN_USER> <WSADMIN_PASSWORD> には、当該環境に適切なWAS管理ユーザー（wasadmin など）と、パスワードを指定してください。
    1. 正常に実行されると、zipファイルが生成されます。

 ## Transformation Advisor 解析結果の確認
 
 1. エージェントの実行結果が、このハンズオンでは以下のリンクに配置されていますので、ローカルのPCにダウンロードします。<br>
  [エージェント実行結果](https://github.com/ICpTrial/ICPLab/blob/master/trfadvimage/DefaultAppSrv01.zip) ※開いたGitHubの画面でダウンロードをクリックしてください。
 1. コンソールの中央にある「Upload Data」を選択し、クリックします。
 1. クリックして開いた画面の「Drop or Add File」を選択し、先にダウンロードした実行結果ファイル `DefaultAppSrv01.zip` を指定し、「Upload」ボタンをクリックします。
 1. レポート結果が開きますので確認していきます。
![report01](https://github.com/ICpTrial/ICPLab/blob/master/trfadvimage/report01.png)
    1. 収集してきたアプリケーションのプロファイル名が表示され、移行先のターゲットとして「Liberty on Private Cloud」が設定されています。
    1. このプロファイルには、アプリケーションが２つ（CustomOrderServiceApp.earとquery.ear）が含まれていることがわかります。<br>
    それぞれ、アプリケーション移行の複雑さは、Moderate （通常レベル）として判断されています。<br>
    この中で、移行に関する課題Issueがそれぞれ、幾つか上がっています。<br>
    ここでは CustomOrderServiceApp.ear を展開して、詳細を確認していきます。<br>
    
 1. CustomOrderServiceApp.earをクリックして開きます。
    1. 上部にはアプリケーションの概要や、アプリケーションの変更を行う場合の工数の目安が記載されています。<br>
    ただしこれはあくまでツールから外から考えられる数字ですので、お客様の実態にあわせて考える必要があります。あくまで目安とお考えください。<br>
    ![report02](https://github.com/ICpTrial/ICPLab/blob/master/trfadvimage/report02.png)
    1. テクニカル・イシューとして１つ重要レベルの課題があがっており、「Behavior change on lookups for Enterprise JavaBeans」が上げられています。
    ![report03](https://github.com/ICpTrial/ICPLab/blob/master/trfadvimage/report03.png)
    　　これは赤印がついていますので、マイグレーションの際に実際に対応しないといけない課題です。

 1. テクニカルな課題を確認するために、最下部にある３つのレポートを確認していきます。<br>
 まず「Analytics Report」を確認します。先ほどの解析のなかで Issuseとして上がっている内容の詳細を確認できます。<br>
 ![analyticreport01](https://github.com/ICpTrial/ICPLab/blob/master/trfadvimage/analyticreport01.png)
    1. 「Detailed Results by Rule」に先ほど確認した課題のリストの詳細があります。
    1. 「Behavior change on lookups for Enterprise JavaBeans」の show result を開いて、どのファイルに問題があるか確認します。showrule help を開くと、どのような課題なのかを確認することができ、場合によっては修正の仕方のガイドがあります。
    ![analyticreport02](https://github.com/ICpTrial/ICPLab/blob/master/trfadvimage/analyticreport02.png)
    1. その他の結果についても同様に確認してください．

    
 1. 「Technical Report」を確認します。これはアプリケーションで利用されているAPIのリストが表示されます。<br>
 　　様々なアプリケーション・サーバー環境がリストされていますが、チェックが入っていない環境では当該のAPIが稼働しません。<br>
   　そのテクノロジーの移行を考えるか、移行先をサポートされるものの中から選ぶかを実施する必要があります。<br>
    ![techreport01](https://github.com/ICpTrial/ICPLab/blob/master/trfadvimage/techreport01.png)
    
 1. 「Inventory Report」は、当該のアプリケーションの構造を示してくれます。保守するメンバーがいなくなってしまった場合などに、アプリケーションの作りの概要を理解するのに役立ちます。
  ![migrationreport02](https://github.com/ICpTrial/ICPLab/blob/master/trfadvimage/inventoryreport.png)
      
  
 ## Migration Planの作成
 
 1. ツールが作成してくれた構成ファイルを利用して、マイグレーションを検討していきます。<br>
 Recommendationの画面から「Migration Plan」のボタンをクリックします。<br>
 ![migration01](https://github.com/ICpTrial/ICPLab/blob/master/trfadvimage/migration01.png)
 1. ボタンを開くと、当該アプリケーションをコンテナ化するための様々な構成ファイルがリストされます。<br>
 それぞれの構成ファイルを開いて確認してみましょう。<br>

 1. Application Bundle をクリックして、アプリケーションを関連付けます。<br>
 ここでは、[アプリケーション](https://github.com/ICpTrial/ICPLab/blob/master/trfadvimage/CustomerOrderServicesApp.ear) をダウンロードして利用します。
 ![migration01](https://github.com/ICpTrial/ICPLab/blob/master/trfadvimage/migration02.png)
　
 1. アプリケーションまで関連付けると、「Deploy Bundle」ボタンを押すことができるようになります。<br>
 これにより、GitHubのコード・レポジトリ および ICP上の CI/CD環境 Microclimate まで関連づけていくことが可能です。
    1.右の「Deploy Bundle」を選択します。
    ![migration03](https://github.com/ICpTrial/ICPLab/blob/master/trfadvimage/migration03.png)
    1. 別途 GitHub 上に作成したプロジェクトのURLを指定します。認証情報を USERID/PASSWORD で指定してください。<br>
    GitHub URL<br>
    一人目　https://github.com/ICpTrial/lab601/ <br>
    二人目　https://github.com/ICpTrial/lab602/ <br>
    予備　　https://github.com/ICpTrial/lab603/ <br>
    1. ICP上のMicroclimate の URLを指定します。<br>
    `http://microclimate.<icp_proxy_address>.nip.io`<br>
    1. 「Deploy」をクリックします。一連の生成されたコードとアプリケーションがGitHub上に登録され、そこから Mircoclimate のプロジェクトが生成されます。<br>
    ![migration04](https://github.com/ICpTrial/ICPLab/blob/master/trfadvimage/migration04.png)
 
 
 以上で、Lab9は終了です。
