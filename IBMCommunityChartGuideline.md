# IBMコミュニティチャートリポジトリ

IBM Community chartリポジトリーは、HelmリポジトリーとHelmチャートのソースコードのリポジトリーの両方であり、IBM Cloud Privateで使用するためのコミュニティ開発のHelmチャートをホストすることを目的としています。GitHubの次の場所にあります。

 - チャートのソース：[https://github.com/IBM/charts/tree/master/community/](https://github.com/IBM/charts/tree/master/community/）
 - Helmリポジトリ：[https://github.com/IBM/charts/tree/master/repo/community](https://github.com/IBM/charts/tree/master/repo/community）

IBM Cloud Privateのカタログ・ビューには、HelmリポジトリのリストをポーリングすることでデプロイできるHelmチャートのセットが表示されます。デフォルトでは、これらのリポジトリには、IBM Cloud Privateクラスタ自体の内部でローカルにホストされているHelmリポジトリ、およびIBMが開発したチャート用のIBMのチャートリポジトリが含まれています。[https://raw.githubusercontent.com/IBM/charts] /master/repo/stable/](https://raw.githubusercontent.com/IBM/charts/master/repo/stable/）

IBM Cloud Private 2.1.0.3の時点では、IBM Community chartリポジトリーはデフォルトでカタログに表示されませんが、将来デフォルトのリポジトリーのリストに追加される可能性があります。ユーザーは**管理＆gt;に移動して、自分のカタログビューにリポジトリを追加できます。 IBM Cloud Privateユーザー・インターフェースのHelmリポジトリー**、および追加[https://raw.githubusercontent.com/IBM/charts/master/repo/community/](https://raw.githubusercontent.com/IBM/charts / master / repo / community /）をリストに追加します。

＆nbsp;

＃IBM®Cloud Private用のヘルムチャートの作成

この文書は、IBM Cloud Private用のHelmチャートを作成し、それらをIBM Communityのチャートリポジトリに提供することを目的としています。

IBM Cloud Privateは、独自のインフラストラクチャー上にコンテナー・ベースのワークロードをデプロイおよび管理するためのKubernetesベースの環境を提供します。 IBM Cloud Privateワークロードは[Helm]（https://helm.sh/）を使用してデプロイされ、すべてのIBM Cloud Privateクラスターは[Tiller]（https://docs.helm.sh/glossary/#tiller）を含みます。他のKubernetesベースの環境にデプロイできるほとんどのHelmチャートは、変更を加えずにIBM Cloud Privateクラスターにデプロイできます。

この文書の手引きは、IBM Communityのチャート・リポジトリーへの貢献の基準を満たすチャートを作成し、IBM Cloud Privateにデプロイするときにユーザーに付加価値を提供するためにIBM Cloud Privateプラットフォームと統合するチャートを作成するのに役立ちます。 。これらのガイドラインに従って作成されたチャートは、他の標準Kubernetes環境との互換性を維持しますが、IBMが開発および提供したチャートをデプロイしたときに見られるエクスペリエンスと同様に、IBM Cloud Privateのユーザーエクスペリエンスを強化します。

＆nbsp;

＃IBMコミュニティチャートリポジトリへの貢献

IBM Communityチャートリポジトリへの貢献に関する規則は、GitHubリポジトリ自体でホストされている[CONTRIBUTING.md]（https://github.com/IBM/charts/blob/master/CONTRIBUTING.md）でカバーされています。

すべての寄付には、チャートのソースとパッケージ化されたHelmチャートの両方を含める必要があります。チャートのソースは `chart / community`ディレクトリに追加する必要があり、パッケージ化されたチャートの` .tgz`ファイルはHelmレポジトリディレクトリに追加する必要があります、 `chart / repo / community`

さらに、貢献ガイドラインでは、貢献するすべてのHelmチャートはApache 2.0ライセンスの下でライセンス供与する必要があり、すべての貢献にはコードをこのコミュニティに貢献する権利を証明する開発者サインオフを含める必要があります。 Origin]（https://developercertificate.org/）。

＆nbsp;

チャート投稿のための＃基準とガイドライン

以下の表は、Helmチャートを `https：// github.com / ibm / chart / community`ディレクトリに配信する準備をしている人のための準備ガイドとして使用する必要があります。 [** Table 1 **]（＃table-1-httpsgithubcomibmchartに貢献したすべてのチャートに必要）は、IBM Communityチャートリポジトリに貢献したすべてのチャートに必要な標準の短いリストを含みます。 [**表2 **]（＃ibm-cloud-privateでの改善されたユーザーエクスペリエンスに関する推奨事項）には、プラットフォームとさらに統合するチャートの作成方法に関するガイダンスが含まれています。 IBM Cloud Privateで高品質で一貫したユーザー・エクスペリエンスを提供します。表2のガイドラインを推奨しますが、必須ではありません。チャートの各項目には、このページのさらに下にある実装に関する詳細へのリンクがあります。

これらのガイドラインは[Helmベストプラクティス]（https://docs.helm.sh/chart_best_practices/）を補強することを目的としており、それらを置き換えるものではありません。下記のガイダンスがない場合は、Helmコミュニティのベストプラクティスを参照することをお勧めします。

###表1：https://github.com/ibm/chartsに投稿されたすべてのチャートに必要

| **要件** | **説明** |
| --- | --- |
| [**ディレクトリ構造**]（＃directory-structure）|チャートのソースは `chart / community`ディレクトリに追加されなければなりません。 `helm package`を使って` .tgz`ファイルとしてパッケージ化されたチャートアーカイブは、Helmリポジトリである `chart / repo / community`ディレクトリに追加されなければなりません。 *あなたの貢献*でindex.yamlを更新しないでください。 index.yamlはビルドプロセスによって自動的に更新されます。
| [**チャート名**]（＃chart-name）|舵チャートの名前は[舵チャートのベストプラクティス]（https://github.com/kubernetes/helm/blob/master/docs/chart_best_practices/conventions.md#chart-names）に従う必要があります。チャート名は、チャートを含むディレクトリと同じである必要があります。会社または組織によって提供された図表には、会社または組織の名前を接頭辞として付けることができます。 IBMによって提供されたチャートのみにibm- |というプレフィックスを付けることができます。
| [**チャートファイルの構造**]（＃chart-file-structure）|チャートは標準のHelmファイル構造に従う必要があります。Chart.yaml、values.yaml、README.md、templates、templates / NOTES.txtはすべて存在し、有用な内容を持っている必要があります。
| [**チャートバージョン**]（＃chart-version）| [Helmチャートのベストプラクティス]（https://github.com/kubernetes/helm/blob/master/docs/chart_best_practices/conventions.md#version-numbers）に従って、SemVer2番号を使用し、チャートを更新する必要があります。変更がREADMEファイルのみに対するものでない限り、更新されたバージョン番号を含める必要があります。
| [**チャートの説明**]（＃chart-description）|提供されたすべてのチャートは、chart.yamlにチャートの説明がなければなりません。これはICPカタログに表示され、意味があるはずです。 |
| [**チャートのキーワード**]（＃chart-keywords）| ChartキーワードはIBM Cloud Privateユーザー・インターフェースによって使用され、Chart.yamlに含める必要があります。チャートがIBM Cloud Privateでの使用を意図していることを示すためにキーワード「ICP」を使用し、チャートがIBM Cloud Kubernetesサービスでの使用を意図していることを示すためにキーワード「IKS」を使用します。チャートには、 `s390x`、` ppc64le`、そして `amd64`のセットから、それがサポートするハードウェアアーキテクチャを示すための1つ以上のキーワードも含まなければなりません。 UIの分類に使用されるオプションのキーワードのリストは、オプションのガイダンスをカバーするセクションに続きます。 |
| [** Helm lint **]（＃helm-lint）|チャートはエラーなしで `helm lint`検証ツールに合格しなければなりません。 |
| [**ライセンス**]（＃ライセンス）|チャート自体はApache 2.0ライセンスであり、チャートのルートにあるLICENSEファイルにApache 2.0ライセンスが含まれている必要があります。チャートは、展開されている製品のライセンスなど、追加のライセンスファイルをLICENSESディレクトリにパッケージ化することもできます。 IBM Cloud Privateユーザー・インターフェースを介してデプロイする際には、LICENSEファイルとLICENSESディレクトリー内のファイルの両方が同意のためにユーザーに表示されます。
| [** README.md **]（＃readme-md）|提供されるすべてのチャートには、ユーザがチャートをデプロイするために必要となる有用な情報を含む便利なREADME.mdファイルが含まれている必要があります。 IBM Cloud Private GUIでは、README.mdファイルはカタログのチャートをクリックした後にユーザーに表示される「フロントページ」です。すべての入力パラメータの完全な説明と説明を強くお勧めします。 [container image security]（https://www.ibm.com/support/knowledgecenter/en/SSBS6K_3）から、IBM Cloud Privateの信頼できるイメージレジストリのリストにイメージレジストリを追加する方法についても説明することを強くお勧めします。 IBM Cloud Private 3.1以降、デフォルトで1.0 / manage_images / image_security.html）が有効になります。 |
| [**サポート文**]（＃support-statement）| README.mdは `Support`とラベルされたセクションを含まなければなりません。このセクションでは、ユーザーが緊急の問題のサポートを受ける、支援を受ける、または問題を送信できる場所への詳細および/またはリンクを提供する必要があります。 |
| [** NOTES.txt **]（＃notes-txt）|使用上の注意、次の手順を表示するための手順と一緒にNOTES.txtを含めます。関連情報|
| [** tillerVersion constraint **]（＃tillerversion-constraint）| Semantic Versioning 2.0.0フォーマット（ `> = MAJOR.MINOR.PATCH`）に従う` tillerVersion`をChart.yamlに追加してください。このバージョン番号に追加のメタデータが添付されていないことを確認してください。このチャートが機能することが確認された最も低いバージョンのHelmにこの制約を設定します。 |
| [**デプロイメント検証**]（＃deployment-validation）|チャートは、Helm CLIとIBM Cloud Private GUIの両方を使用して、IBM Cloud Privateの最新バージョンで正常にデプロイされ、期待どおりに機能するように検証する必要があります。 [Vagrantを使用してIBM Cloud Privateをデプロイする]（https://github.com/IBM/deploy-ibm-cloud-private/blob/master/docs/deploy-vagrant.md）チャートを確認するための環境を素早く立ち上げることができます。 |

＆nbsp;

＆nbsp;

###表2：IBM Cloud Privateのユーザーエクスペリエンス向上のための推奨事項

次の表には、IBM Cloud Privateでフル機能で一貫したユーザーエクスペリエンスを提供するワークロードを構築する方法に関するIBMからのガイダンスが含まれています。上記の標準とは異なり、IBM Communityチャートリポジトリ内のチャートは、これらの項目を実装するために必須ではありません。チャート開発者は、ベストプラクティス以下の項目を検討し、必要に応じてそれらを使用して、IBM Cloud Privateとのより深い統合を実現し、ユーザーエクスペリエンスを向上させる必要があります。一部の推奨事項は、すべての作業負荷タイプに適用できるわけではありません。

| **ガイドライン** | **説明** |
| --- | --- |
| [チャートアイコン]（＃chart-icon）|ネストしたチャートを使用するときのチャートサイズの制限を回避するために、アイコンにURLを提供することは、チャートにローカルアイコンを埋め込むよりも好ましいです。 |
| [チャートのキーワード]（＃chart-keywords-1）|前のセクションで説明した必須キーワードに加えて、オプションのキーワードを使用してチャートをUIによって認識される一連のカテゴリに絞り込むことができます。
| [チャートのバージョン/画像のバージョン]（＃chart-version-image-version）|ワークロードは、チャートのバージョンとは別にイメージのバージョン/タグを管理する必要があります。 |
| [画像]（＃画像）|画像URLをパラメータ化し、展開する画像のバージョンをデフォルトとして最新バージョンで公開する必要があります。可能であれば、デフォルトで公開されている画像を参照してください。 |
| [マルチプラットフォームサポート]（＃multi-platform-support）| IBM Cloud Privateは、x86-64、Power、およびzハードウェア・アーキテクチャーをサポートしています。ワークロードは、3つのプラットフォームすべてにイメージを提供し、太い目録を使用することによって、可能な限り多くのユーザーに到達できます。 |
| [コンテナ定義の初期化]（＃init-container-definitions）| [initコンテナ]（https://kubernetes.io/docs/concepts/workloads/pods/init-containers/）を使用する場合は、それらを記述するために `spec`構文vs` annotations`を使用してください。これらのアノテーションはKubernetes 1.6と1.7では非推奨となり、Kubernetes 1.8ではサポートされなくなりました。 |
| [ノードアフィニティ]（＃node-affinity）| IBMは、ワークロードが異種クラスター内の有効なプラットフォーム上でスケジュールされるようにするために `nodeAffinity`を使用することをお勧めします。
| [ストレージ（永続ボリューム/要求）]（＃storage-persistent-volumes-claim）|割り当ては環境固有であり、チャートの配置担当者には許可されていないため、チャートに永続的なボリュームを作成しないでください。永続的ストレージが必要な場合は、チャートに永続的ボリューム要求を含める必要があります。 |
| [パラメータのグループ化と命名]（＃パラメータのグループ化と命名）|チャート全体で一貫したパラメーターとユーザーエクスペリエンスを提供するには、共通の命名規則（オンボーディングガイドに概説）を使用してください。 |
| [値メタデータ]（＃values-metadata）| ICP UIで豊富な展開エクスペリエンスを提供するために、パスワード、許可された値などを含むフィールドのメタデータを定義します。メタデータフォーマットは、オンボーディングガイドに記載されています。 |
| [ラベルと注釈]（＃labels-and-annotations）| IBMは、すべてのKubernetesリソースで、すべての図表に「遺産、リリース、図表およびアプリ」という標準ラベルを使用することをお勧めします。 |
| [活気と即応性プローブ]（＃liveness-and-readyiness-probes）|ワークロードは、livenessProbesとreadinessProbesを使用して自分の健康状態を監視する監視を有効にする必要があります。 |
| [種類]（＃種類）|リソースを定義するすべてのHelmテンプレートは `Kind`を持たなければなりません。 Helmはデフォルトでポッドになっていますが、これは避けています。ヘルムのベストプラクティスは、単一のテンプレートファイルに複数のリソースを定義しないことです。 |
| [コンテナセキュリティ権限]（＃container-security-privilege）|可能な限り、ワークロードはコンテナーに対してエスカレートされたセキュリティー特権を使用しないでください。昇格した特権が必要な場合、チャートは目的の機能を実現するために必要な最小レベルの特権を要求する必要があります。 |
| [Kubernetesセキュリティ特権]（＃kubernetes-security-privilege）|チャートは、クラスタ管理者などの管理ロールを持たない通常のユーザが配置できるようにします。昇格した役割が必要な場合は、チャートのREADME.mdに明確に文書化されている必要があります。
| [hostPathを避ける]（＃avoid-hostpath）|堅牢なストレージソリューションではないため、hostPathストレージの使用は避けてください。 |
| [hostNetworkを避ける]（＃avoid-hostnetwork） hostNetworkを使用することは避けてください。コンテナーが共存するのを防ぐためです。 |
| [ドキュメントリソース使用量]（＃document-resoure-usage）|チャートはチャートの `README.md`に文書化されている、それらが消費するリソースについて明確であるべきです。
| [測光]（＃測光）|ユーザーがIBM Cloud Privateメータリングサービスで使用量を測定できるように、チャートにメータリング注釈を含める必要があります。 |
| [ロギング]（＃ロギング）|ワークロード・コンテナーはログをstdoutおよびstderrに書き込む必要があるため、IBM Cloud Privateロギング・サービス（Elasticsearch / Logstash / Kibana）によって自動的に消費されます。また、README.mdに関連するKibanaダッシュボードへのリンクを含めることをお勧めします。ユーザーはそれらをダウンロードしてKibanaにインポートできます。 |
| [モニタリング]（＃モニタリング）|ワークロードはデフォルトのIBM Cloud Privateモニタリングサービス（Prometheus / Grafana）と統合する必要があります。PrometheusメトリックスをKubernetesの「Service」で公開し、そのエンドポイントに注釈を付けてIBM Cloud Privateモニタリングサービスによって自動的に消費されるようにします。 |
| [ライセンスキーと料金]（＃ライセンスキーと料金）|チャートにデプロイまたは他の方法でワークロードを使用するためにライセンスキーが必要な場合は、チャートのREADME.mdの「前提条件」セクションに記載する必要があります。 |

＃詳細なガイダンス

-------------------------------------

＃チャートの要件

このセクションには、[GUIDELINES.md]（https://github.com/IBM/charts/blob/master/GUIDELINES.md）で概説されているように、IBM Communityチャートに貢献するすべてのチャートが従うべき標準のリストが含まれています。 。チャートは、Helmコミュニティから公開されている[Helmベストプラクティス]（https://docs.helm.sh/chart_best_practices/）に準拠していることが期待されます。ここでは再現しません。

##ディレクトリ構造

チャートのソースはchart / communityディレクトリに追加する必要があります。 helmパッケージを使用して.tgzファイルとしてパッケージ化されたチャートアーカイブは、helmリポジトリであるchart / repo / communityディレクトリに追加する必要があります。

**あなたの貢献で** chart / repo / community / index.yamlを更新しないでください。** index.yamlはプルリクエストが処理されるときにビルドプロセスによって自動的に更新されます。**

##チャート名

舵チャートの名前は[舵チャートのベストプラクティス]（https://github.com/kubernetes/helm/blob/master/docs/chart_best_practices/conventions.md#chart-names）に従ってください。チャート名はチャートソースを含むディレクトリと同じである必要があります。会社または組織によって提供されたチャートには、会社または組織の名前を接頭辞として付けることができます。コミュニティからの投稿の前に＆quot; ibm-＆quot;を付けないでください。

## Chartファイルの構造

チャートは標準のHelmファイル構造に従う必要があります。Chart.yaml、values.yaml、README.md、templates、およびtemplates / NOTES.txtはすべて存在し、有用な内容を持つべきです。

##チャートのキーワード

ChartキーワードはIBM Cloud Privateユーザー・インターフェースによって使用され、Chart.yamlに含める必要があります。チャートがIBM Cloud Privateでの使用を意図していることを示すためにキーワード「ICP」を使用し、チャートがIBM Cloud Kubernetesサービスでの使用を意図していることを示すためにキーワード「IKS」を使用します。チャートには、 `s390x`、` ppc64le`、そして `amd64`のセットから、それがサポートするハードウェアアーキテクチャを示すための1つ以上のキーワードも含まなければなりません。 UIの分類に使用されるオプションのキーワードのリストは、オプションのガイダンスをカバーするセクションに続きます。

##チャートバージョン

[Helmチャートのベストプラクティス]（https://github.com/kubernetes/helm/blob/master/docs/chart_best_practices/conventions.md#version-numbers）に従って、SemVer2番号付けを使用する必要があります。

##チャートの説明

すべてのチャートはchart.yamlにチャートの説明がなければなりません。これはICPカタログUIに表示され、エンドユーザーにとって意味があるはずです。

##ヘルムリント

すべてのチャートはエラーなしで `helm lint`検証ツールに合格しなければなりません。

##ライセンス

チャート自体はApache 2.0ライセンスであり、チャートのルートにあるLICENSEファイルにApache 2.0ライセンスが含まれている必要があります。チャートは、展開されている製品のライセンスなど、追加のライセンスファイルをLICENSESディレクトリにパッケージ化することもできます。 IBM Cloud Privateユーザー・インターフェースを介してデプロイするときには、LICENSEファイルとLICENSESディレクトリー内のファイルの両方が同意のためにユーザーに表示されます。

## README.md

提供されるすべてのチャートには、ユーザがチャートをデプロイするために必要となる有用な情報を含む便利なREADME.mdファイルが含まれている必要があります。 IBM Cloud Private GUIでは、README.mdファイルはカタログのチャートをクリックした後にユーザーに表示される「フロントページ」です。すべての入力パラメータの完全な説明と説明を強くお勧めします。

また、チャートを展開する前に、ユーザーが自分のレジストリをIBM Cloud Privateの信頼できるレジストリのリストに追加する必要があることに注意することを強くお勧めします。 [container image security]から、IBM Cloud Privateの信頼できるイメージレジストリのリストにイメージレジストリを追加する方法についての指示（またはリンク）を含めてください（https://www.ibm.com/support/knowledgecenter/en/）。 IBM Cloud Private 3.1以降、SSBS6K_3.1.0 / manage_images / image_security.html）がデフォルトで有効になります。

##サポート文

README.mdは `Support`とラベルされたセクションを含まなければなりません。このセクションでは、ユーザーが製品に関する緊急の問題のサポートを受けること、ヘルプを得ること、または問題を送信することができる場所への詳細および/またはリンクを提供する必要があります。

## NOTES.txt

すべてのチャートには、使用上の注意、次の手順を表示するための手順を含むNOTES.txtが含まれている必要があります。関連情報NOTES.txtは、デプロイ後にIBM Cloud Privateユーザー・インターフェースによって表示されます。

## tillerVersion制約

Semantic Versioning 2.0.0フォーマット（\＆gt; = MAJOR.MINOR.PATCH）に従うtillerVersionをChart.yamlに追加します。このバージョン番号に追加のメタデータが添付されていないことを確認してください。このチャートが機能することが確認された最も低いバージョンのHelmにこの制約を設定します。

##デプロイ検証

チャートをIBM Communityのチャートリポジトリに追加するプルリクエストを作成する前に、チャートの所有者は、IBM Cloud PrivateのユーザーインターフェイスとHelmコマンドラインの両方を使用して、チャートが最新バージョンのIBM Cloud Privateに正しくデプロイされることを確認する必要があります。さらに、チャートでは動作しないことがわかっているIBM Cloud Privateのバージョンがある場合は、それらの詳細をREADME.mdの「制限事項」などのセクションに明確に指定する必要があります。例： `このチャートはIBM Cloud Privateバージョン3.1.0以上でのみサポートされています。
[Vagrantを使用してIBM Cloud Privateをデプロイする]（https://github.com/IBM/deploy-ibm-cloud-private/blob/master/docs/deploy-vagrant.md）自分の環境を確認するための環境を素早く立ち上げることができます。チャート。

＆nbsp;

＃推奨チャート機能

このセクションには、プラットフォームによって提供される機能とサービスを利用することによって、エンドユーザーにIBM Cloud Privateの付加価値を提供する提案のリストが含まれています。これらはIBM Communityチャートリポジトリへの投稿には必要ありませんが、それらを実装することを強くお勧めします。それらがIBMによって開発されたチャートで提供されるものと同様の拡張されたエクスペリエンスを提供するためです。

##チャートアイコン

ヘルムチャートは `Chart.yaml`の` icon`属性を使ってアイコンへのリンクを指定するべきです。アイコン参照を含まないチャートの場合、デフォルトのアイコンがカタログのUIに表示されます。
グラフファイルを小さくするために、グラフにアイコンファイルを直接含めるのではなく、公衆インターネット上のアイコンへのリンクを含めることをお勧めします。ヘルムチャートの最大サイズは1MBです。個々のチャートがその制限に近づくことはありませんが、ユーザはチャートをサブチャートとして含むチャートを作成することがあるため、外部リンクを使用することをお勧めします。
アイコンがGitHubファイルでホストされている `.svg`の場合、ICP UIで正しく表示するためにURLの最後に`？sanitize = true`を追加してください。例えば：

`` `
アイコン：https://raw.githubusercontent.com/ot4i/ace-helm/master/appconnect_enterprise_logo.svg?sanitize=true
`` `

##チャートのキーワード

ChartキーワードはIBM Cloud Privateユーザーインターフェースによって使用され、Chart.yamlに含まれるべきです。チャートがIBM Cloud Privateでの使用を意図していることを示すためにキーワード「ICP」を使用し、チャートがIBM Cloud Kubernetesサービスでの使用を意図していることを示すためにキーワード「IKS」を使用します。チャートは、 `s390x`、` ppc64le`、そして `amd64`のセットから、それがサポートするハードウェアアーキテクチャを示すための1つ以上のキーワードも含むべきです。

| **ラベル：** | **キーワード** |
| --- | --- |
| AIとワトソン： 「ワトソン、AI」|
|ブロックチェーン：ブロックチェーン
|ビジネスオートメーション： `businessrules`、` Automation` |
|データ： |データベース
|データサイエンス＆分析：データサイエンス、アナリティクス|
| DevOps： 「DevOps」、「deploy」、「Development」、「IDE」、「Pipeline」、「ci」、「build」|
| IoT： `IoT` |
|操作：操作|
|統合： `統合`、 `メッセージキュー` |
|ネットワーク：ネットワーク
|ランタイムとフレームワーク： `runtime`、` framework` |
|ストレージ：ストレージ
|セキュリティ：セキュリティ
|ツール：ツール

##チャートバージョン/イメージバージョン

ワークロードは、チャートのバージョンとは別にイメージのバージョン/タグを管理する必要があります。

##イメージ

画像URLはvalues.yamlへのパラメータ化された参照であるべきであり、そして展開されるべき画像のバージョンはデフォルトとして最新バージョンで公開されるべきであり、デフォルトで公に利用可能な画像を参照するべきです。

##マルチプラットフォームサポート

IBM Cloud Privateは、x86-64、ppc64le、およびz（s390）ハードウェア・アーキテクチャーをサポートしています。ワークロードは、3つのプラットフォームすべてにイメージを提供し、太い目録を使用することによって、可能な限り多くのユーザーに到達できます。

ppc64leプラットフォーム用のイメージの開発について詳しくは、[IBM Cloud Private on Power]（https://developer.ibm.com/linuxonpower/ibm-cloud-private-on-power/）および[Docker on IBM Power]を参照してください。システム]（https://developer.ibm.com/linuxonpower/docker-on-power/）のサイト[developer.ibm.com]（https://developer.ibm.com）

zプラットフォーム用のイメージの開発について詳しくは、[IBM Systems上のLinux用のIBM Knowledge Center]（https://www.ibm.com/support/knowledgecenter/en/linuxonibm/com.ibm.linux.z）を参照してください。 ldvd / ldvd_c_docker_image.html）

##脂肪のマニフェスト

個々のコンテナイメージには、特定のアーキテクチャ用にコンパイルされたバイナリが含まれています。 「ファットマニフェスト」と呼ばれる概念を使用して、単一の画像参照から複数のアーキテクチャに対応できるようにするマニフェストリストを作成できます。 Dockerデーモンがそのようなイメージにアクセスすると、現在実行中のプラットフォームアーキテクチャと一致するイメージに自動的にリダイレクトされます。

この機能を使用するには、各アーキテクチャのDockerイメージをレジストリにプッシュし、その後に太い目録を付ける必要があります。

###太ったマニフェストをデプロイする

太いマニフェストをデプロイするための推奨される方法は、docker tooling、すなわちマニフェストサブコマンドを使用することです。まだPRレビュープロセスに入っていますが、マルチアーチイメージを作成して任意のdockerレジストリにプッシュするために簡単に使用できます。

docker-cliツールは、さまざまなプラットフォーム用にこちらからダウンロードできます。[https://github.com/clnperez/cli/releases/tag/v0.1](https://github.com/clnperez/cli/releases/tag /v0.1）

たとえば、次の画像名を使って `web-terminal`コンポーネントの太い目録を作るには：

  -  `mycluster.icp：8500 / default / ibmcom / web-terminal：2.8.1`  - マルチアーチイメージの名前
  -  `mycluster.icp：8500 / default / ibmcom / web-terminal：2.8.1-x86_64`  -  x86_64イメージの名前
  -  `mycluster.icp：8500 / default / ibmcom // Web端末：2.8.1-ppc64le`  - 電源イメージの名前
  -  `mycluster.icp：8500 / default / ibmcom / web-terminal：2.8.1-s390`  -  Zイメージの名前

`` `
./docker-linux-amd64マニフェスト作成mycluster.icp：8500 /デフォルト/ ibmcom / web-terminal：2.8.1 mycluster.icp：8500 /デフォルト/ ibmcom / web-terminal：2.8.1-86_64 mycluster.icp：8500 /default/ibmcom/web-terminal:2.8.1-ppc64le mycluster.icp：8500 / default / ibmcom / web-terminal：2.8.1-s390x
./docker-linux-amd64マニフェスト注釈mycluster.icp：8500 /デフォルト/ ibmcom / web-terminal：2.8.1 mycluster.icp：8500 /デフォルト/ ibmcom / web-terminal：2.8.1-x86_64 --os linux  - -arch amd64
./docker-linux-amd64マニフェスト注釈mycluster.icp：8500 /デフォルト/ ibmcom / web-terminal：2.8.1 mycluster.icp：8500 /デフォルト/ ibmcom / web-terminal：2.8.1-ppc64le --os linux  - -arch ppc64le
./docker-linux-amd64マニフェスト注釈mycluster.icp：8500 /デフォルト/ ibmcom / web-terminal：2.8.1 mycluster.icp：8500 /デフォルト/ s390x / web-terminal：2.8.1-s390x --os linux  - -arch s390x
./docker-linux-amd64マニフェスト検査mycluster.icp：8500 / default / ibmcom / web-terminal：2.8.1
./docker-linux-amd64マニフェスト・プッシュmycluster.icp：8500 / default / ibmcom / web-terminal：2.8.1
`` `

**注意：**マルチアーチイメージをレジストリにプッシュしても、イメージレイヤーはプッシュされません。アクセス可能な画像へのポインタのリストをプッシュするだけです。これが、マルチアーチ画像を実際のもの、つまりマニフェストリストと考える方がよい理由です。さらに、ファットマニフェストを作成するときは、プラットフォーム固有のDockerイメージがすべてレジストリに事前にインポートされていることを確認する必要があります。そうしないと、ターゲットイメージと異なるレジストリのソースイメージを使用できないというエラーが表示されます。 ！= mycluster.icp：8500`。

マニフェストリストをレジストリにプッシュした後は、以前イメージ名を使用していたときと同じように使用します。

**注：**マニフェストリストのローカルコピーを保持したい場合は、-purgeフラグを削除してください。忘れた場合、 `manifest inspect`はレジストリのコピーではなくローカルのコピーを返すので、これを使うことをお勧めします。

## initコンテナの定義

[init container]（https://kubernetes.io/docs/concepts/workloads/pods/init-containers/）は、アプリケーションコンテナと一緒にパッケージ化したくないユーティリティをパッケージ化するなど、さまざまな理由で役に立ちます。あるいは、すべてのコンテナーを並行して開始するべきではないワークロードのための開始順序ロジックを含めるため。

initコンテナを使用している場合、kubernetesのドキュメントで説明されているように、それらを記述するために `annotations`の代わりに` spec`構文を使用してください。注釈はKubernetes 1.6と1.7では非推奨となり、Kubernetes 1.8ではサポートされなくなりました。

##ノードアフィニティ

IBMは、[nodeAffinity]（https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#node-affinity-beta-feature）を使用して有効なプラットフォームにチャートのインストールをスケジュールすることをお勧めします。

ノードアフィニティは、そのアーキテクチャに基づいて、ポッドが実行されるノードを制限する機能を提供します。異種クラスタでは、特定のハードウェアアーキテクチャを持つノードでのみ特定のワークロードを実行するかどうかをユーザーが選択できます。

IBMは[ibm-odm-dev]（https://github.com/IBM/charts）に示されているように、 `arch.パラメーターを` values.yaml`に追加し、そのパラメーターを参照してポッドに `nodeAffinity`を設定することをお勧めします。例えば、/ blob / master / stable / ibm-odm-dev / templates / deploy.yaml）chartです。

##ストレージ（固定ボリューム/クレーム）

割り当ては環境固有であり、チャートの配置担当者には許可されていないため、チャート内に永続的なボリュームを作成することはお勧めできません。永続的なストレージが必要な場合は、チャートに[kubernetesのドキュメント]（https://kubernetes.io/docs/concepts/storage/persistent-volumes/#writing-portable-configuration）に記載されているように、Persistent Volume Claimを含める必要があります。

管理者が展開のために事前に作成しなければならない必要な永続ボリュームまたはストレージクラスは、README.mdに明確に文書化されている必要があります。

##パラメータのグループ化と命名

[値に関するHelmベストプラクティス]（https://github.com/kubernetes/helm/blob/master/docs/chart_best_practices/values.md）には、[命名規則]（https://github.com/kubernetes）のガイドラインが含まれています。 /helm/blob/master/docs/chart_best_practices/values.md#naming-conventions）、[使用方法（マップではなく配列）]（https://github.com/kubernetes/helm/blob/master/docs/chart_best_practices/ values.md＃ユーザーが自分の値を使用する方法を検討する）、[YAMLフォーマット]（https://github.com/kubernetes/helm/blob/master/docs/chart_best_practices/values.md#flat-） or-nested-values）、[タイプの明確化]（https://github.com/kubernetes/helm/blob/master/docs/chart_best_practices/values.md#make-types-clear）。以下のガイドラインは、共通の名前、値、およびグループ化を使用することによって、チャート全体で一貫したユーザーエクスペリエンスを提供するためにこれらを基にしています。複数のインスタンスが存在する場合（例えば、複数のPersistentVolumeClaimが必要な場合、パラメータはpvc1、pvc2、…のようなグループ化トークンの下にネストされるべきです）、ネストされた構造はグループ化を最初のトークンとして定義されます。

 - パラメータは、ネストされた値が `.`で区切られた1つ以上のトークンで構成されている必要があります。トークンの左から右への読み取りは、一貫して次の順序と名前で行われる必要があります（パラメータが特定のチャートに適用可能な場合）。
  1.グループ化/命名トークン（複数のインスタンスの場合 - すなわちpvc1、pvc2）
  修飾子（すなわち持続性）
  3.パラメータ（有効）
 - チャート全体でグループとして設定されることが多いフィールドには、グローバルパラメータをお勧めします。これにより、チャートを変更せずにサブチャートとして使用できるようになります。一般的な例は `global.image.secretName`で、これが設定されていれば` imagePullSecret`です：

  values.yamlからの抜粋：

  `` `
        グローバル：
          画像：
            secretName：＆quot; docker-secret＆quot;
  `` `

  ポッドからの抜粋：

  `` `
        {{ -  if .Values.global.image.secretName}}
        imagePullSecrets：
           - 名前：{{.Values.global.image.secretName}}
        {{- 終わり }}
  ```
共通のIBM Cloud Privateパラメーター

| **パラメータ** | **定義** | **値** |
| --- | --- | --- |
| image.pullPolicy | Kubernetesイメージプルポリシー常に、しない、またはIfNotPresent。最新のタグが指定されている場合はデフォルトのAlways、それ以外の場合はIfNotPresentがデフォルトになります。 |
| image.repository |リポジトリ接頭辞を含む画像の名前（必要な場合） [Dockerタグの詳細説明]（https://docs.docker.com/edge/engine/reference/commandline/tag/#description）を参照してください。
| image.tag | Dockerの画像タグ| [Dockerタグの説明]（https://docs.docker.com/edge/engine/reference/commandline/tag/#description）を参照してください。
| persistence.enabled |持続性ボリューム（PV）が有効真、偽|
| persistence.storageClassNameまたは[volume] .storageClassName | Kubernetesシステム管理者によって事前作成されたStorageClass。 | |
| persistence.existingClaimNameまたは[volume] .existingClaimName |特定の事前作成されたPersistence Volume Claim（PVC）の名前。 |
| persistence.sizeまたは[volume] .size |必要なストレージアプリケーションの量（Gi、Mi） |
| resources.limits.cpu |許可されるCPUの最大量を説明します。 | [Kubernetes  -  CPUの意味]（https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/#meaning- of-cpu）を参照してください。
| resources.limits.memory |許可されている最大メモリ量を示します。 | [Kubernetes  - メモリの意味]（https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/#meaning-of-memory）を参照してください。
| resources.requests.cpu |必要なCPUの最小量を記述します - 指定されていない場合はデフォルトでlimit（指定されている場合）またはそれ以外の場合は実装定義の値になります。 | [Kubernetes  -  CPUの意味]（https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/#meaning- of-cpu）を参照してください。
| resources.requests.memory |必要な最小メモリ量を記述します。指定されていない場合、デフォルトでlimit（指定されている場合）、またはそれ以外の場合は実装定義の値になります。 | [Kubernetes  - メモリの意味]（https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/#meaning-of-memory）を参照してください。
| service.type |サービスの種類を指定|有効なオプションは、ExternalName、ClusterIP、NodePort、およびLoadBalancerです。 [公開サービス - サービスの種類]（https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services---service-types）を参照してください。

追加のガイダンス：

 - 型変換エラーを避けるための文字列の引用符共通IB
 - （必要ならば）ライセンス受諾文字列はvalues.yamlの中で `受諾されない`にデフォルトであるべきであり、GUIでユーザによって受諾されるとき `受諾`に設定されるでしょう。

##値メタデータ

IBM Cloud Privateは、パスワードを含むフィールド、非表示フィールド、チェックボックスとしてのブール値のレンダリング、チェックボックス、許可値の指定などのメタデータの定義をサポートして、IBM Cloud Private GUIでの豊富なデプロイメント体験を提供します。このメタデータは `values-metadata.yaml`という名前のファイルを使ってチャート内で定義されます。このファイルの使用方法の例については、[このリポジトリのサンプルチャート]（https://github.com/IBM/charts/blob/master/community/sample-chart/values-metadata.yaml）を参照してください。多数の[チャートリポジトリにIBM提供のチャート]（https://github.com/IBM/charts/tree/master/stable）

##ラベルと注釈

Helmは[ラベルと注釈]の作成に関する一連のベストプラクティスを定義しています（https://github.com/kubernetes/helm/blob/master/docs/chart_best_practices/labels.md）。このドキュメントで扱う概念は、リソースを識別し、オペレータなどのツールにクエリ可能なラベルを提供できるメタデータに焦点を当てています。したがって、リソースのラベルはまとめて一意にする必要があります。さらに、「ベストプラクティス」リンクには、ヘルムチャートが使用する一般的なラベルのセットが記載されています。

チャートで定義されているすべてのKubernetesリソースで、すべてのチャートが「遺産、リリース、チャート、およびアプリ」の標準ラベルを使用することをお勧めします。

##活気とレディネスプローブ

チャートソース

##種類

リソースを定義するすべてのhelmテンプレートには「種類」が必要です。 [Helmベストプラクティス]（https://github.com/kubernetes/helm/blob/master/docs/chart_template_guide/yaml_techniques.md）は、単一のテンプレートファイルに複数のリソースを定義しないようにすることです。

##コンテナセキュリティ特権

可能な限り、ワークロードはコンテナーに対してエスカレートされたセキュリティー特権を使用しないでください。昇格した特権が必要な場合、チャートは目的の機能を実現するために必要な最小レベルの特権を要求する必要があります。

IBMでは、 `securityContext`の中で、` privilege：true`や `capabilities：add：[" ALL "]の使用を避けることを推奨しています。高度な特権が必要な場合は、目的の機能を実装するために必要な最小限の特権のみを追加することをお勧めします。

## Kubernetesのセキュリティ特権

チャートは、クラスタ管理者などの管理ロールを持たない通常のユーザが配置できるようにします。昇格したKubernetesの役割が必要な場合は、これをチャートのREADME.mdに明確に記載する必要があります。

## hostPathを避ける

堅牢なストレージソリューションではないので、 `hostPath`ストレージの使用は避けてください。 `hostPath`は動的なプロビジョニング、冗長性、あるいはノード間でポッドを移動する機能をサポートしません。

## hostNetworkを避ける

ポッドが `hostNetwork：true`で設定されている場合、そのようなポッドで実行されているアプリケーションはポッドが開始されたワーカーノードのネットワークインターフェースを直接見ることができます。これは、アプリケーションがホストマシンのすべてのネットワークインターフェースでアクセス可能になることを意味します。

これにより、2つのポッドが同じポートを使用するのを防ぎ、特定のノードのIPアドレスに依存することになります。

ホストネットワーキングは、アプリケーションをクラスタの外部からアクセス可能にするための良い方法ではありません。 IBMはこれを達成するために `NodePort`または` Ingress`を使うことを提案しました。

ネットワークモニタやイングレスコントローラのように、ホストレベルのネットワーキングに直接アクセスする必要があるチャートを作成しているのでなければ、IBMは `hostNetwork`を避けることを推奨します。

##ドキュメントリソースの使用量

チャートには、必要な最小のCPU、メモリ、ストレージのリソース、およびデフォルトで要求されるCPU、メモリ、およびストレージの量をREADME.mdで明確に文書化する必要があります。

##メーター統合

IBM Cloud Privateメータリングサービスは、実行中のワークロードを構成するコンテナ化されたコンポーネントによって利用可能、上限が設定されている、および/または利用されている仮想プロセッサコアに基づいて、IBM Cloud Privateで実行されているコンテナの使用情報を収集します。

仮想コア情報は、IBM Cloud Privateクラスター内で稼働している計測デーモンによって自動的に収集されます。適切なメトリックが収集され、実行中のオファリングに起因するように、ワークロードはこのデーモンに対して自分自身を識別する必要があります。

メタデータは、計測目的で収集されたメトリクスと展開されたオファリングを関連付けるために使用されます。メータリングサービスは、実行中のオファリングのメトリックを単純に測定し、UIを介して、そしてダウンロード可能なCSV形式のデータとして、過去の使用状況データをユーザーに提供します。

ワークロードは、ポッドのメタデータアノテーションを使用して、メーターリーダーの製品ID、製品名、および製品バージョンを指定する必要があります。これは、特定の展開のためのヘルムチャートのスペックテンプレートセクションで定義されています。

  - 製品名（「ｐｒｏｄｕｃｔＮａｍｅ」）は、人間が読むことができるオファリングの名前である。
  - 商品識別子（ `productID`）はオファリングを一意に識別します（一意性を保証するためにあなたの会社または組織名で名前空間を付けてください）
  - 製品バージョン識別子（ `productVersion`）はオファリングのバージョンを指定します

`` `
    種類：展開
    スペック：
      テンプレート：
         メタデータ：
           注釈：
              productName：IBMサンプルチャート
              productID：com.ibm.chartscommunity.samplechart.0.1.2
              製品バージョン：0.1.2
`` `

##ロギング統合

IBM Cloud Privateノードは、標準出力および標準エラー・ストリームに書き込まれたログ・データを自動的に収集し、それを統合ロギング・サービス（Elasticsearch / Logstash / Kibana）に転送するようになっています。

ワークロード・コンテナーは、個別のログ・ファイルではなく、ログ・データをstdoutおよびstderrに書き込む必要があります。これにより、それらはIBM Cloud Privateロギング・サービスによって自動的に消費される可能性があります。ユーザーがそれらをダウンロードしてKibanaにインポートできるように、ワークロードには関連するKibanaダッシュボードへのリンクをREADME.mdに含めることをお勧めします。

##モニタリング統合

ワークロードはデフォルトのIBM Cloud Privateモニタリングサービス（Prometheus / Grafana）と統合する必要があります。PrometheusメトリックスをKubernetesの「Service」で公開し、そのエンドポイントに注釈を付けてIBM Cloud Privateモニタリングサービスによって自動的に消費されるようにします。 IBMは、独自のPrometheusまたはGrafanaのインスタンスをパッケージ化するのではなく、プラットフォームの監視サービスと統合することをお勧めします。これにより、ユーザーは中央のインスタンスからすべてのデータを取得でき、オーバーヘッドが削減されます。

PrometheusエンドポイントをIBM Cloud Privateモニター・サービスに公開するには、以下の例に示すようにアノテーション `prometheus.io/scrape： 'true'`を使用してください。

`` `
    apiVersion：v1
    種類：サービス
    メタデータ：
      注釈：
        prometheus.io/scrape： 'true'
      ラベル：
        app：{{テンプレート "フルネーム"。 }}
      名前：{{テンプレート "フルネーム"。メトリクス
    スペック：
      ports：
       - 名前：{{.Values.service.name}}  - メトリック
        targetPort：9157
        ポート：9157
        プロトコル：TCP
      セレクタ：
        app：{{テンプレート "フルネーム"。 }}
      タイプ：ClusterIP
`` `

個々のメトリックス名は、ワークロードの名前を前に付ける必要があります（例えば、 `ibmmq_object_mqput_bytes`）。

##ライセンスキーと価格
チャートにデプロイまたは他の方法でワークロードを使用するためにライセンスキーが必要な場合は、チャートのREADME.mdの「前提条件」セクションに記載する必要があります。さらに、キーの入手方法に関する指示、および価格設定と試用に関する情報も、このステートメントと一緒に含めるかリンクして、チャートのインストールとワークロードの使用に必要なキーを容易に入手できるようにする必要があります。
