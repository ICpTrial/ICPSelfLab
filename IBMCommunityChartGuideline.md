※ この文書は [IBM Community Chart Guideline](https://github.com/IBM/charts/blob/master/GUIDELINES.md) (As of 2019/01/09) の翻訳です。更新の有無については原文をご確認ください。

# IBM Community Chart リポジトリ

IBM Community chartリポジトリーは、HelmリポジトリーとHelmチャートのソースコードのリポジトリーの両方であり、IBM Cloud Privateで使用するためのコミュニティ開発のHelmチャートをホストすることを目的としています。GitHubの次の場所にあります。

 - チャートのソース：[https://github.com/IBM/charts/tree/master/community/](https://github.com/IBM/charts/tree/master/community/)
 - Helmリポジトリ：[https://github.com/IBM/charts/tree/master/repo/community
 ](https://github.com/IBM/charts/tree/master/repo/community)

IBM Cloud Privateのカタログ・ビューには、複数のHelmリポジトリから構成されるHelmチャートのセットが表示されます。デフォルトでは、これらのリポジトリには、IBM Cloud Privateクラスタ自体の内部でローカルにホストされているHelmリポジトリ、およびIBMが開発したチャート用のIBMのチャートリポジトリが含まれています。[https://raw.githubusercontent.com/IBM/charts/master/repo/stable/](https://raw.githubusercontent.com/IBM/charts/master/repo/stable/)

IBM Cloud Private 2.1.0.3の時点では、IBM Community chartリポジトリーはデフォルトでカタログに表示されませんが、将来デフォルトのリポジトリーのリストに追加される可能性があります。ユーザーは**管理** に移動して、自分のカタログビューにリポジトリを追加できます。 IBM Cloud Privateユーザー・インターフェースから、IBM Community の Helm chartリポジトリー[https://raw.githubusercontent.com/IBM/charts/master/repo/community/](https://raw.githubusercontent.com/IBM/charts/master/repo/community/)をリストに追加してください。

----

# IBM® Cloud Private用のHELMチャートの作成

この文書は、IBM Cloud Private用のHelmチャートを作成し、それらをIBM Communityのチャート・リポジトリに登録することを目的としています。

IBM Cloud Privateは、お客様自身が管理できるインフラストラクチャー上に、Kubernetesベースの環境を提供し、コンテナー・ベースのワークロードをデプロイおよび管理します。IBM Cloud Privateワークロードは[Helm](https://helm.sh/)を使用してデプロイされ、すべてのIBM Cloud Privateクラスターは[Tiller](https://docs.helm.sh/glossary/#tiller)を含みます。他のKubernetesベースの環境にデプロイできるHelmチャートは、通常、変更を加えずにIBM Cloud Privateクラスターにデプロイできます。

この文書のガイドは、IBM Communityのチャート・リポジトリーへの登録の基準を満たすチャートを作成し、IBM Cloud Privateにデプロイするときにユーザーに付加価値を提供するためにIBM Cloud Privateプラットフォームと統合するチャートを作成するのに役立ちます。<br>
これらのガイドラインに従って作成されたチャートは 他の標準Kubernetes環境との互換性を維持しますが、IBMが開発および提供したチャートをデプロイしたときに見られるエクスペリエンスと同様に、IBM Cloud Privateにおけるユーザー・エクスペリエンスをより強化します。

----

# IBMコミュニティチャートリポジトリへの貢献

IBM Communityチャートリポジトリへの貢献に関するルールは、GitHubリポジトリにホストされている[CONTRIBUTING.md](https://github.com/IBM/charts/blob/master/CONTRIBUTING.md) にカバーされています。

登録する場合には、チャートのソースとパッケージ化されたHelmチャートの両方を含める必要があります。チャートのソースは `chart/community`ディレクトリに追加する必要があり、パッケージ化されたチャートの`.tgz`ファイルはHelmレポジトリ・ディレクトリ`chart/repo/community` に追加する必要があります。

さらに、登録ガイドラインでは、登録するすべてのHelmチャートはApache 2.0ライセンスの下でライセンス供与する必要があり、すべての登録にはコードをこのコミュニティに貢献する権利を証明する [Developer Certificate of Origin](https://developercertificate.org/) を含める必要があります。

----

# チャート投稿のための基準とガイドライン

以下の表は、Helmチャートを `https://github.com/ibm/chart/community`ディレクトリに配信する準備をしている人のための準備ガイドとして使用する必要があります。<br>
[**表１**](#表１ https://github.com/ibm.chart に登録すべてのチャートに必要)は、IBM Communityチャート・リポジトリに登録するすべてのチャートに必要な基準の短いリストを含みます。<br>
[**表２**](#表２ ibm cloud privateでの改善されたユーザーエクスペリエンスに関する推奨事項) には、ICPのプラットフォームとさらに統合するチャートの作成方法に関するガイダンスが含まれています。IBM Cloud Privateで高品質で一貫したユーザー・エクスペリエンスの提供が可能になります。表2のガイドラインに従うことを推奨しますが、必須ではありません。チャートの各項目には、このページのさらに下にある実装に関する詳細へのリンクがあります。<br>

これらのガイドラインは[Helmベストプラクティス](https://docs.helm.sh/chart_best_practices/) を補強することを目的としており、それらを置き換えるものではありません。下記のガイダンスがない場合は、Helmコミュニティのベスト・プラクティスを参照することをお勧めします。

### 表1：https://github.com/ibm/chartsに投稿されたすべてのチャートに必要

| **要件** | **説明** |
| ------- | ------- |
| [**ディレ#クトリ構造**](#directory-structure)|チャートのソースは `chart/community`ディレクトリに追加されなければなりません。`helm package`を使って`.tgz`ファイルとしてパッケージ化されたチャートアーカイブは、Helmリポジトリである `chart/repo/community`ディレクトリに追加されなければなりません。 *あなたの成果物*でindex.yamlを更新しないでください。index.yamlはビルドプロセスによって自動的に更新されます。|
| [**チャート名**](#chart-name)|Helmチャートの名前は[Helmチャートのベストプラクティス](https://github.com/kubernetes/helm/blob/master/docs/chart_best_practices/conventions.md#chart-names) に従う必要があります。チャート名は、チャートを含むディレクトリと同じである必要があります。会社または組織によって提供された図表には、会社または組織の名前を接頭辞として付けることができます。IBMによって提供されたチャートのみに`ibm-`というプレフィックスを付けることができます。|
| [**チャートファイルの構造**](#chart-file-structure)|チャートは標準のHelmファイル構造に従う必要があります。Chart.yaml、values.yaml、README.md、templates、templates/NOTES.txt はすべて存在し、有用な内容を持っている必要があります。|
| [**チャートバージョン**](#chart-version)| [Helmチャートのベストプラクティス](https://github.com/kubernetes/helm/blob/master/docs/chart_best_practices/conventions.md#version-numbers)に従って、SemVer2ナンバリングを使用し、チャートを更新する必要があります。変更がREADMEファイルのみに対するものでない限り、更新されたバージョン番号を含める必要があります。|
| [**チャートの説明**](#chart-description)|提供されたすべてのチャートは、chart.yamlにチャートの説明がなければなりません。これはICPカタログに表示され、意味があるものでなければいけません。|
| [**チャートのキーワード**](#chart-keywords)| ChartキーワードはIBM Cloud Privateユーザー・インターフェースによって使用されます。Chart.yamlに含める必要があります。チャートがIBM Cloud Privateでの使用を意図していることを示すためにはキーワード「ICP」を使用し、チャートがIBM Cloud Kubernetesサービスでの使用を意図していることを示すためにはキーワード「IKS」を使用します。チャートには、 `s390x`、` ppc64le`、そして `amd64`のセットから、それがサポートするハードウェア・アーキテクチャを示すための1つ以上のキーワードも含まなければなりません。UIの分類に使用されるオプションのキーワードのリストは、オプションのガイダンスをカバーするセクションに続きます。|
| [**Helm lint**](#helm-lint)|チャートはエラーなしで `helm lint`検証ツールに合格しなければなりません。 |
| [**ライセンス**](#license)|チャート自体はApache 2.0ライセンスであり、チャートのルートにあるLICENSEファイルにApache 2.0ライセンスが含まれている必要があります。チャートは、展開されている製品のライセンスなど、追加のライセンスファイルをLICENSESディレクトリにパッケージ化することもできます。 IBM Cloud Privateユーザー・インターフェースを介してデプロイする際には、LICENSEファイルとLICENSESディレクトリー内のファイルの両方が同意のためにユーザーに表示されます。
| [**README.md**](#readme-md)|提供されるすべてのチャートには、ユーザがチャートをデプロイするために必要となる有用な情報を含む便利なREADME.mdファイルが含まれている必要があります。 IBM Cloud Private GUIでは、README.mdファイルはカタログのチャートをクリックした後にユーザーに表示される「フロント・ページ」です。すべての入力パラメータの完全な説明と記述を強くお勧めします。また、IBM Cloud Privateの信頼できるイメージ・レジストリのリストにイメージ・レジストリを追加する方法についても説明することを強くお勧めします。 IBM Cloud Private 3.1以降、デフォルトで [コンテナ・イメージ・セキュリティ](https://www.ibm.com/support/knowledgecenter/ja/SSBS6K_3.1.0/manage_images/image_security.html)が有効になります。|
| [**サポート・ステートメント**](#support-statement)| README.mdは `Support`とラベルされたセクションを含まなければなりません。このセクションでは、ユーザーが緊急の問題をあげる、支援を受ける、または問題の報告をあげるための詳細およびリンクを提供する必要があります。 |
| [**NOTES.txt**](#notes-txt)|使用上の注意、次の手順、関連情報を得るための情報を NOTES.txtを含めます。|
| [**tillerVersion制約**](#tillerversion-constraint)| Semantic Versioning 2.0.0フォーマット( `> = MAJOR.MINOR.PATCH`)に従う` tillerVersion`をChart.yamlに追加してください。このバージョン番号に追加のメタデータが添付されていないことを確認してください。このチャートが機能することが確認された最も低いバージョンのHelmにこの制約を設定します。 |
| [**デプロイメント検証**](#deployment-validation)|チャートは、Helm CLIとIBM Cloud Private GUIの両方を使用して、IBM Cloud Privateの最新バージョンで正常にデプロイされ、期待どおりに機能するように検証する必要があります。 [Vagrantを使用してIBM Cloud Privateをデプロイする](https://github.com/IBM/deploy-ibm-cloud-private/blob/master/docs/deploy-vagrant.md)チャートを確認するための環境を素早く立ち上げることができます。 |

### 表2：IBM Cloud Private におけるユーザー・エクスペリエンス向上のための推奨事項

次の表には、IBM Cloud Private のフル機能で一貫したユーザーエクスペリエンスを提供するワークロードを構築する方法に関するIBMからのガイダンスが含まれています。表１の標準とは異なり、IBM Communityチャート・リポジトリ内のチャートは、これらの項目をすべて実装することは必須ではありません。チャート開発者は、ベスト・プラクティス以下の項目を検討し、必要に応じてそれらを使用して、IBM Cloud Privateとのより深い統合を実現し、ユーザー・エクスペリエンスを向上させることができます。一部の推奨事項は、すべてのワークロード・タイプに適用できるわけではありません。

| **ガイドライン** | **説明** |
| -------------- | ------- |
| [チャート・アイコン](#chart-icon)|ネストしたチャートを使用する際に、チャー・サイズの制限を回避するために、アイコンにURLを利用することは、チャート内にローカル・アイコンを埋め込むよりも好ましいです。 |
| [チャートのキーワード](#chart-keywords-1)|前のセクションで説明した必須キーワードに加えて、オプションのキーワードを使用して、UIによって認識される一連のカテゴリで絞り込んでチャートを表示できます。
| [チャートのバージョン/イメージのバージョン](#chart-version-image-version)|ワークロードは、チャートのバージョンとは別に、イメージのバージョン/タグを管理する必要があります。 |
| [イメージ](#image)|画像URLをパラメータ化し、展開する画像のバージョンをデフォルトとして最新バージョンで公開する必要があります。可能であれば、デフォルトで公開されている画像を参照してください。 |
| [マルチプラットフォームサポート](#multi-platform-support)| IBM Cloud Privateは、x86-64、Power、およびzハードウェア・アーキテクチャーをサポートしています。ワークロードは、3つのプラットフォームすべてにイメージを提供し、fat manifestを使用することによって、可能な限り多くのユーザーに到達できます。 |
| [Initコンテナー定義](#init-container-definitions)| [initコンテナ](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/)を使用する場合は、それらを記述するために`annotations`ではなく`spec`構文を使用してください。これらのアノテーションはKubernetes 1.6と1.7では非推奨となり、Kubernetes 1.8ではサポートされなくなりました。 |
| [ノード・アフィニティ](#node-affinity)| IBMは、ワークロードが異種クラスター内の有効なプラットフォーム上でスケジュールされるようにするために `nodeAffinity`を使用することをお勧めします。
| [ストレージ(PersistentVolume/Claim)](#storage-persistent-volumes-claim)| チャートにPersistent Volumeを作成しないでください 割り当ては環境固有であり、チャートのデプロイ担当者には許可されていないこともあります。永続的ストレージが必要な場合は、チャートに永続的ボリューム要求 (Persitent Volume Claim) を含める必要があります。 |
| [パラメータのグループ化と命名](#パラメータのグループ化と命名)|チャート全体で一貫したパラメーターとユーザーエクスペリエンスを提供するには、共通の命名規則(オンボーディングガイドに概説)を使用してください。 |
| [Valuesメタデータ](#values-metadata)| ICP UIで優れたデプロイメント・エクスペリエンスを提供するために、パスワード、許可された値などを含むフィールドのメタデータを定義します。メタデータフォーマットは、オンボーディングガイドに記載されています。 |
| [ラベルと注釈](#labels-and-annotations)| IBMは、すべてのKubernetesリソースで、すべてのに「heritage, release, chart, app」という標準ラベルを利用することをお勧めします。 |
| [liveness ProbesとreadinessProve即応性プローブ](#liveness-and-readiness-probes)|ワークロードは、livenessProbesとreadinessProbesを使用して自分のヘルスの監視を有効にする必要があります。 |
| [Kind](#Kind)|リソースを定義するすべてのHelmテンプレートは`Kind`を持たなければなりません。 Helmはデフォルトでポッドになっていますが、我々はこれを避けています。Helmのベストプラクティスは、単一のtemplateファイルに複数リソースを定義しないことです。|
| [コンテナ・セキュリティ権限](#container-security-privilege)|可能な限り、ワークロードはコンテナーに対して昇格したセキュリティー特権を使用しないでください。チャートに昇格した特権が必要な場合、目的の機能を実現するために必要な最小レベルの特権を要求する必要があります。 |
| [Kubernetesセキュリティ特権](#kubernetes-security-privilege)|チャートは、クラスタ管理者などの管理ロールを持たない通常のユーザがデプロイできるようにします。昇格した役割が必要な場合は、チャートのREADME.mdに明確にドキュメントされている必要があります。|
| [hostPathを避ける](#avoid-hostpath)|堅牢なストレージ・ソリューションではないため、hostPathストレージの使用は避けてください。 |
| [hostNetworkを避ける](#avoid-hostnetwork)|hostNetworkを使用することは避けてください。コンテナーが共存することができなくなります。 |
| [ドキュメントリソース使用量](#document-resoure-usage)|チャートは消費するリソースについて明確であり、チャートの`README.md`に文書化するべきです。|
| [メータリング](#metering)|ユーザーがIBM Cloud Privateメータリングサービスで使用量を測定できるように、チャートにメータリング・アノテーションを含める必要があります。|
| [ロギング](#logging)|ワークロード・コンテナーはログをstdoutおよびstderrに書き出すべきです。これにより、IBM Cloud Privateロギング・サービス(Elasticsearch / Logstash / Kibana)によって自動的に管理されます。また、README.mdに関連するKibanaダッシュボードへのリンクを含めることをお勧めします。ユーザーはそれらをダウンロードしてKibanaにインポートできます。 |
| [モニタリング](#モニタリング)|ワークロードはデフォルトのIBM Cloud Privateモニタリング・サービス(Prometheus/Grafana)と統合する必要があります。PrometheusメトリックスをKubernetesの`Service`で公開し、そのエンドポイントにアノテーションを付けてIBM Cloud Privateモニタリング・サービスによって自動的に管理されるようにします。 |
| [ライセンスキーと料金](#ライセンスキーと料金)|ワークロードをデプロイするために、または他の方法でワークロードを使用するために、ライセンス・キーが必要な場合は、チャートのREADME.mdの「前提条件」セクションに記載する必要があります。 |

-----
# 詳細なガイダンス

## チャートの必須要件
このセクションには、[GUIDELINES.md](https://github.com/IBM/charts/blob/master/GUIDELINES.md)で概説されているように、IBM Communityチャートに貢献するすべてのチャートが従うべき標準のリストが含まれています。チャートは、Helmコミュニティから公開されている[Helmベスト・プラクティス](https://docs.helm.sh/chart_best_practices/)に準拠していることが期待されます。ここでは繰り返しません。

### ディレクトリ構造
チャートのソースは `chart/community` ディレクトリに追加する必要があります。 helmパッケージを使用して.tgzファイルとしてパッケージ化されたチャートアーカイブは、helmリポジトリである `chart/repo/community `ディレクトリに追加する必要があります。

**あなたの成果物で `chart/repo/community/index.yaml`を更新しないでください。index.yamlはプル・リクエストが処理されるときに実行さえっるビルド・プロセスによって自動的に更新されます。**

### チャート名
Helmチャートの名前は[Helmチャートのベスト・プラクティス](https://github.com/kubernetes/helm/blob/master/docs/chart_best_practices/conventions.md#chart-names)に従ってください。チャート名はチャート・ソースを含むディレクトリと同じである必要があります。会社または組織によって提供されたチャートには、会社または組織の名前を接頭辞として付けることができます。コミュニティからの登録に"ibm-"を付けないでください。

### Chartファイルの構造
チャートは標準のHelmファイル構造に従う必要があります。Chart.yaml、values.yaml、README.md、templates、およびtemplates / NOTES.txtはすべて存在し、有意な内容を持つべきです。

### チャートのキーワード
ChartキーワードはIBM Cloud Privateユーザー・インターフェースによって使用され、Chart.yamlに含める必要があります。チャートがIBM Cloud Privateでの使用を意図していることを示すためにキーワード`ICP`を使用し、チャートがIBM Cloud Kubernetesサービスでの使用を意図していることを示すためにキーワード`IKS`を使用します。チャートには、 `s390x`、` ppc64le`、そして `amd64`のセットから、それがサポートするハードウェアアーキテクチャを示すための1つ以上のキーワードも含まなければなりません。 UIの分類に使用されるオプションのキーワードのリストは、オプションのガイダンスをカバーするセクションに続きます。

### チャート・バージョン
[Helmチャートのベスト・プラクティス](https://github.com/kubernetes/helm/blob/master/docs/chart_best_practices/conventions.md#version-numbers)に従って、SemVer2ナンバリングを使用する必要があります。

### チャートの説明
すべてのチャートはchart.yamlにチャートの説明 Description がなければなりません。これはICPカタログUIに表示され、エンドユーザーにとって意味があるものにするべきです。

### helm lint
すべてのチャートはエラーなしで `helm lint`検証ツールに合格しなければなりません。

### ライセンス
チャート自体はApache 2.0ライセンスであり、チャートのルートにあるLICENSEファイルにApache 2.0ライセンスが含まれている必要があります。チャートは、展開されている製品のライセンスなど、追加のライセンスファイルを`LICENSES`ディレクトリにパッケージ化することもできます。 IBM Cloud Privateユーザー・インターフェースを介してデプロイするときには、LICENSEファイルとLICENSESディレクトリー内のファイルの両方が同意のためにユーザーに表示されます。

### README.md
提供されるすべてのチャートには、ユーザがチャートをデプロイするために必要となる有用な情報を含む便利なREADME.mdファイルが含まれている必要があります。 IBM Cloud Private GUIでは、README.mdファイルはカタログのチャートをクリックした後にユーザーに表示される「フロント・ページ」です。すべての入力パラメータの完全な説明と記述を強くお勧めします。<br>
また、チャートをデプロイする前に、ユーザーが IBM Cloud Privateの信頼できるレジストリのリストに自分のレジストリを 追加する必要があることに注意を促してください。IBM Cloud Private 3.1以降、デフォルトで [コンテナ・イメージ・セキュリティ](https://www.ibm.com/support/knowledgecenter/ja/SSBS6K_3.1.0/manage_images/image_security.html)が有効になります。

### サポート文
README.mdは `Support`とラベルされたセクションを含まなければなりません。このセクションでは、ユーザーが製品に関する緊急の問題のサポートを受けること、ヘルプを得ること、または問題を送信することができる場所への詳細やリンクを提供する必要があります。

### NOTES.txt
すべてのチャートには、使用上の注意、次の手順を表示するための手順、および関連情報を含むNOTES.txtが含まれている必要があります。NOTES.txtは、デプロイ後にIBM Cloud Privateユーザー・インターフェースによって表示されます。

### tillerVersion制約
Semantic Versioning 2.0.0フォーマット（ MAJOR.MINOR.PATCH）に従うtillerVersionをChart.yamlに追加します。このバージョン番号に追加のメタ・データが添付されていないことを確認してください。このチャートが機能することが確認された最も低いバージョンのHelmにこの制約を設定します。

### デプロイ検証
チャートをIBM Communityのチャート・リポジトリに追加する`Pull Request`を作成する前に、チャートの所有者は、IBM Cloud Privateのユーザー・インターフェイスとHelmコマンドラインの両方を使用して、チャートが最新バージョンのIBM Cloud Privateに正しくデプロイされることを確認する必要があります。さらに、チャートでは動作しないことがわかっているIBM Cloud Privateのバージョンがある場合は、それらの詳細をREADME.mdの「制限事項」などのセクションに明確に指定する必要があります。例：`このチャートはIBM Cloud Privateバージョン3.1.0以上でのみサポートされています`
[Vagrantを使用してIBM Cloud Privateをデプロイする](https://github.com/IBM/deploy-ibm-cloud-private/blob/master/docs/deploy-vagrant.md) を利用することで、環境を素早く立ち上げ チャートを確認することができます。


## 推奨チャート機能
このセクションには、プラットフォームによって提供される機能とサービスを利用することによって、エンドユーザーにIBM Cloud Privateの付加価値を提供する提案のリストが含まれています。これらはIBM Communityチャートリポジトリへの登録には必要ありませんが、それらを実装することを強くお勧めします。それらがIBMによって開発されたチャートで提供されるものと同様の拡張されたエクスペリエンスを提供するためです。

### チャート・アイコン
Helmチャートは `Chart.yaml`の`icon`属性を使ってアイコンへのリンクを指定するべきです。アイコン参照を含まないチャートの場合、デフォルトのアイコンがカタログのUIに表示されます。
画像ファイルを小さくするために、グラフにアイコンファイルを直接含めるのではなく、パブリック・インターネット上のアイコンへのリンクを含めることをお勧めします。Helmチャートの最大サイズは1MBです。個々のチャートがその制限に近づくことはありませんが、ユーザはチャートをサブ・チャートとして含むチャートを作成することがあるため、外部リンクを使用することをお勧めします。
アイコンがGitHubファイルでホストされている`.svg`の場合、ICP UIで正しく表示するためにURLの最後に`？sanitize = true`を追加してください。例えば以下のように記述します。
```
icon: https://raw.githubusercontent.com/ot4i/ace-helm/master/appconnect_enterprise_logo.svg?sanitize=true
```

### チャートのキーワード
ChartキーワードはIBM Cloud Privateユーザー・インターフェースによって使用されますので、Chart.yamlに含むことが望ましいです。チャートがIBM Cloud Privateでの使用を意図していることを示すためにキーワード`ICP`を使用し、チャートがIBM Cloud Kubernetesサービスでの使用を意図していることを示すためにキーワード`IKS`を使用します。チャートは、`s390x`、` ppc64le`、そして `amd64`のセットから、そのちゃーとサポートするハードウェア・アーキテクチャを示すための1つ以上のキーワードも含むべきです。

| **ラベル：** | **キーワード** |
| ------- | ------- |
|AIとワトソン：|`watson`, `AI`|
|ブロックチェーン：|`blockchain`|
|ビジネス・オートメーション：|`businessrules`, `Automation` |
|データ：|`datebase`|
|データサイエンス＆分析：|`Data Science`, `Analytics`|
|DevOps：|`DevOps`, `deploy`,`Development`,`IDE`,`Pipeline`,`ci`,`build`|
|IoT：|`IoT`|
|操作：|`Operations`|
|統合：|`Integrations`,`message queue`|
|ネットワーク：|`network`|
|ランタイムとフレームワーク：|`runtime`,` framework`|
|ストレージ：|`Storage`|
|セキュリティ：|`Security`|
|ツール：|`Tools`|

### チャート・バージョン/イメージ・バージョン
ワークロードは、チャートのバージョンとは別にイメージのバージョン/タグを管理する必要があります。

### イメージ
イメージURLはvalues.yamlへのパラメータ化された参照できるべきです。そしてデプロイされるイメージは、デフォルトでパブリックで利用可能なイメージを参照するべきで、バージョンはデフォルト最新バージョンで公開されるべきです。

### マルチプラット・フォームサポート
IBM Cloud Privateは、x86-64、ppc64le、およびz(s390)ハードウェア・アーキテクチャーをサポートしています。ワークロードは、3つのプラットフォームすべてにイメージを提供し、Fat Manifest を使用することによって、可能な限り多くのユーザーに到達できます。

ppc64leプラットフォーム用のイメージの開発について詳しくは、[IBM Cloud Private on Power](https://developer.ibm.com/linuxonpower/ibm-cloud-private-on-power/)および[Docker on IBM Power](https://developer.ibm.com/linuxonpower/docker-on-power/)のサイト、[developer.ibm.com](https://developer.ibm.com)を参照してください。

zプラットフォーム用のイメージの開発について詳しくは、[IBM Systems上のLinux用のIBM Knowledge Center](https://www.ibm.com/support/knowledgecenter/en/linuxonibm/com.ibm.linux.z.ldvd/ldvd_c_docker_image.html)を参照してください。

   #### Fat Manifest
   個々のコンテナ・イメージには、特定のアーキテクチャ用にコンパイルされたバイナリが含まれています。`Fat Manifest`と呼ばれる概念を使用して、単一のイメージ参照から複数のアーキテクチャに対応できるようにするマニフェスト・リストを作成できます。Dockerデーモンがそのようなイメージにアクセスすると、現在実行中のプラットフォーム・アーキテクチャと一致するイメージに自動的にリダイレクトされます。

   この機能を使用するには、各アーキテクチャのDockerイメージをレジストリにプッシュし、その後にFat Manifestを付ける必要があります。

   #### Fat Manifestをデプロイする
   Fat Manifest のデプロイに推奨される方法は、dockerのツール manifest サブコマンドを使用することです。まだPRレビュー・プロセスの段階ですが、マルチ・アーキテクチャ・イメージを作成して任意のdockerレジストリにプッシュするために簡単に使用できます。

   docker-cliツールは、さまざまなプラットフォーム用にこちらからダウンロードできます。<br>
   [https://github.com/clnperez/cli/releases/tag/v0.1](https://github.com/clnperez/cli/releases/tag/v0.1)

   たとえば、次のイメージ名を使って `web-terminal`コンポーネントのFat Manifestを作る場合：
        -  `mycluster.icp：8500/default/ibmcom/web-terminal：2.8.1` - マルチアーキテクチャ・イメージの名前
        -  `mycluster.icp：8500/default/ibmcom/web-terminal：2.8.1-x86_64` - x86_64イメージの名前
        -  `mycluster.icp：8500/default/ibmcom/web-terminal：2.8.1-ppc64le` - Powerイメージの名前
        -  `mycluster.icp：8500/default/ibmcom/web-terminal：2.8.1-s390` - zイメージの名前

   ```
   ./docker-linux-amd64 manifest create mycluster.icp:8500/default/ibmcom/web-terminal:2.8.1 mycluster.icp:8500/default/ibmcom/web-terminal:2.8.1-86_64 mycluster.icp:8500/default/ibmcom/web-terminal:2.8.1-ppc64le mycluster.icp:8500/default/ibmcom/web-terminal:2.8.1-s390x
   ./docker-linux-amd64 manifest annotate mycluster.icp:8500/default/ibmcom/web-terminal:2.8.1 mycluster.icp:8500/default/ibmcom/web-terminal:2.8.1-x86_64 --os linux --arch amd64
   ./docker-linux-amd64 manifest annotate mycluster.icp:8500/default/ibmcom/web-terminal:2.8.1 mycluster.icp:8500/default/ibmcom/web-terminal:2.8.1-ppc64le --os linux --arch ppc64le
   ./docker-linux-amd64 manifest annotate mycluster.icp:8500/default/ibmcom/web-terminal:2.8.1 mycluster.icp:8500/default/s390x/web-terminal:2.8.1-s390x --os linux --arch s390x
   ./docker-linux-amd64 manifest inspect mycluster.icp:8500/default/ibmcom/web-terminal:2.8.1
   ./docker-linux-amd64 manifest push mycluster.icp:8500/default/ibmcom/web-terminal:2.8.1
   ```

   **注意** 
   マルチ・アーキテクチャ・イメージをレジストリにプッシュしても、イメージ・レイヤーはプッシュされません。アクセス可能なイメージへのポインタのリストをプッシュするだけです。これが、マルチ・アーキテクチャ・イメージを"マニフェスト・スト" と考える方がよい理由です。さらに、Fat Manifestを作成するときは、各プラットフォーム固有のDockerイメージがすべてレジストリに事前にインポートされていることを確認する必要があります。そうしないと、以下のようなターゲットイメージと異なるレジストリのソースイメージを使用できないというエラーが表示されます。<br>
      `cannot use source images from a different registry than the target image: docker.io != mycluster.icp:8500` <br>

   マニフェストリストをレジストリにプッシュした後は、以前イメージ名を使用していたときと同じように利用できます。

   **注意** 
   マニフェストリストのローカルコピーを保持したい場合は、-purgeフラグを削除してください。`manifest inspect`はレジストリのコピーではなくローカルのコピーを返すので、混乱を招く可能性があります。

### initコンテナの定義
[init container](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/)は、アプリケーション・コンテナと一緒にパッケージ化したくないユーティリティをパッケージ化するなど、さまざまな理由で役に立ちます。あるいは、すべてのコンテナーを並行して開始するべきではないワークロードのための開始順序ロジックを含めるためにもりようできます。

initコンテナを使用している場合、kubernetesのドキュメントで説明されているように、それらを記述するために `annotations`の代わりに`spec`構文を使用してください。これらの`annotations` はKubernetes 1.6と1.7では非推奨となり、Kubernetes 1.8ではサポートされなくなりました。

### ノード・アフィニティ
IBMは、[nodeAffinity](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#node-affinity-beta-feature)を使用して、妥当なプラットフォームにチャートのインストールがされるようにします。
ノード・アフィニティは、そのアーキテクチャに基づいて、ポッドが実行されるノードを制限する機能を提供します。異種クラスタでは、特定のハードウェア・アーキテクチャを持つノードでのみ特定のワークロードを実行するかどうかをユーザーが選択できます。
IBMは`arch`パラメーターを`values.yaml`に追加し、そのパラメーターを参照してポッドに`nodeAffinity`を設定することをお勧めします。サンプルとして、[ibm-odm-dev](https://github.com/IBM/charts/blob/master/stable/ibm-odm-dev/templates/deployment.yaml) を見てください。

### ストレージ (Persitent Volume / Persistent Volume Claim)
リソースの割り当ては環境固有であり、チャートのデプロイメント担当者には許可されていないこともあるため、チャート内にPersistentVolume定義を作成することはお勧めできません。永続的なストレージが必要な場合は、チャートに[kubernetesのドキュメント](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#writing-portable-configuration)に記載されているように、Persistent Volume Claimを含める必要があります。

管理者がデプロイのために事前に作成しなければならない必要な永続ボリュームまたはストレージクラスは、README.mdに明確に文書化されている必要があります。

### パラメータのグループ化と命名
[環境変数に関するHelmベストプラクティス](https://github.com/kubernetes/helm/blob/master/docs/chart_best_practices/values.md)には、[命名規則](https://github.com/kubernetes/helm/blob/master/docs/chart_best_practices/values.md#naming-conventions)、[使用方法(マップではなく配列)](https://github.com/helm/helm/blob/master/docs/chart_best_practices/values.md#consider-how-users-will-use-your-values)、[YAMLフォーマット](https://github.com/kubernetes/helm/blob/master/docs/chart_best_practices/values.md#flat-or-nested-values)、[タイプの明確化](https://github.com/kubernetes/helm/blob/master/docs/chart_best_practices/values.md#make-types-clear)のガイドラインが含まれています。 <br>
以下のガイドラインは、共通の名前、値、およびグループ化を使用することによって、チャート全体で一貫したユーザー・エクスペリエンスを提供するためにこれらを基にしています。複数のインスタンスが存在する場合(例えば、複数のPersistentVolumeClaimが必要な場合、パラメータはpvc1、pvc2、…のようなグループ化トークンの下にネストされるべきです)、ネストされた構造はグループ化を最初のトークンとして定義されます。

  #### パラメータは、ネストされた値が`.`で区切られた1つ以上のトークンで構成されている必要があります。<br>
   トークンの左から右への読み取りは、一貫して次の順序と名前で行われる必要があります(パラメータが特定のチャートに適用可能な場合)。
   1. グループ化/命名トークン(複数のインスタンスの場合 - すなわちpvc1、pvc2)
   1. 修飾子(たとえば persistence)
   1. パラメータ(たとえば enabled)
    <br>
    values.yamlからの抜粋：
      ```
         global:
            image:
              secretName: "docker-secret"
      ```
 
  #### チャート全体でグループとして設定されることが多いフィールドには、グローバル・パラメータをお勧めします。<br>
   これにより、チャートを変更せずにサブチャートとして使用できるようになります。
   一般的な例は `global.image.secretName`で、`imagePullSecret`などで利用されます。
    <br>
    ポッド定義からの抜粋：
      ```
            {{ -  if .Values.global.image.secretName}}
            imagePullSecrets：
               - name：{{.Values.global.image.secretName}}
            {{- end }}
      ```
  #### 共通のIBM Cloud Privateパラメーター

   | **パラメータ** | **定義** | **値** |
   | --- | --- | --- |
   | image.pullPolicy | Kubernetesイメージ・プルポリシー |`Always`,`Never`または`IfNotPresent`。<br>`latest`タグが指定されている場合はAlwaysがデフォルト、それ以外の場合はIfNotPresentがデフォルトになります。|
   | image.repository |リポジトリ接頭辞を含むイメージの名前(必要な場合) |[Dockerタグの詳細説明](https://docs.docker.com/edge/engine/reference/commandline/tag/#description)を参照してください。
   | image.tag | Dockerのイメージ・タグ| [Dockerタグの説明](https://docs.docker.com/edge/engine/reference/commandline/tag/#description)を参照してください。
   | persistence.enabled | 永続ボリューム(PersistentVolume)が有効か否か |`true`,`false`|
   | persistence.storageClassName<br>[volume].storageClassName | Kubernetesシステム管理者によって事前作成されたStorageClass。 | |
   | persistence.existingClaimName<br>[volume].existingClaimName | 特定の事前作成されたPersistence Volume Claim(PVC)の名前。 |
   | persistence.size<br>[volume].size |必要なストレージアプリケーションの量(Gi、Mi) |
   | resources.limits.cpu|許可されるCPUの最大量を説明します。| [Kubernetes - CPUの意味](https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/#meaning-of-cpu)を参照してください。
   | resources.limits.memory | 許可されている最大メモリ量を示します。 | [Kubernetes - メモリの意味](https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/#meaning-of-memory)を参照してください。
   | resources.requests.cpu | 必要なCPUの最小量を記述します - 指定されていない場合はデフォルトでlimit(指定されている場合)またはそれ以外の場合は実装で定義された値になります。 | [Kubernetes - CPUの意味](https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/#meaning-of-cpu)を参照してください。
   | resources.requests.memory |必要な最小メモリ量を記述します。指定されていない場合、デフォルトでlimit(指定されている場合)、またはそれ以外の場合は実装で定義された値になります。 | [Kubernetes - メモリの意味](https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/#meaning-of-memory)を参照してください。
   | service.type |サービスの種類を指定|有効なオプションは、`ExternalName`、`ClusterIP`、`NodePort`および`LoadBalancer`です。<br> [公開サービス - サービスの種類](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services---service-types)を参照してください。

  #### 追加のガイダンス
  * 型変換エラーを避けるための文字列の引用符
  * (必要ならば)ライセンス受諾文字列は、values.yamlの中で`not accepted`がデフォルトであるべきであり、GUIでユーザによって受諾されるとき`accept`に設定されるようにします。

### Values メタデータ
IBM Cloud Privateは、パスワードを含むフィールド、非表示フィールド、チェックボックスとしてのブール値のレンダリング、チェックボックス、許可値の指定などのメタデータの定義をサポートして、IBM Cloud Private GUIでの豊富なデプロイメント体験を提供します。このメタデータは `values-metadata.yaml`という名前のファイルを使ってチャート内で定義されます。<br>
  このファイルの使用方法の例については、[このリポジトリのサンプルチャート](https://github.com/IBM/charts/blob/master/community/sample-chart/values-metadata.yaml)や多数の[チャートリポジトリにIBM提供のチャート](https://github.com/IBM/charts/tree/master/stable)を参照してください

### ラベルとアノテーション
Helmは[ラベルと注釈](https://github.com/kubernetes/helm/blob/master/docs/chart_best_practices/labels.md) の作成に関して、一連のベストプラクティスを定義しています。このドキュメントは、リソースを識別し、オペレータなどのツールにクエリ可能なラベルを提供できるメタデータに焦点を当てています。したがって、リソースのラベルはまとめて一意にする必要があります。さらに「ベストプラクティス」リンクには、Helmチャートが使用する一般的なラベルのセットが記載されています。
IBMは、チャートで定義されているすべてのKubernetesリソースで、すべてのチャートが"heritage, release, chart and app"」の標準ラベルを使用することをお勧めします。

### liveneess Prove とreadiness Prove
ワークロードは、livenessProbesとreadinessProbesを使用して自分のヘルスの監視を有効にする必要があります。
  
### Kind
リソースを定義するすべてのhelmテンプレートには`Kind`が必要です。 [Helmベスト・プラクティス](https://github.com/kubernetes/helm/blob/master/docs/chart_template_guide/yaml_techniques.md)は、単一のテンプレート・ファイルに複数のリソースを定義しないようにすることです。

### コンテナ・セキュリティ特権
可能な限り、ワークロードはコンテナーに対して昇格されたセキュリティー特権を使用しないでください。昇格した特権が必要な場合、チャートは目的の機能を実現するために必要な最小レベルの特権を要求する必要があります。
IBMでは、 `securityContext`の中で、`privilege：true`や `capabilities：add：[" ALL "]`の使用を避けることを推奨しています。高度な特権が必要な場合は、目的の機能を実装するために必要な最小限の特権のみを追加することをお勧めします。

### Kubernetesのセキュリティ特権
チャートは、クラスタ管理者などの管理ロールを持たない通常のユーザがデプロイできるようにします。昇格したKubernetesの役割が必要な場合は、これをチャートのREADME.mdに明確に記載する必要があります。

### hostPathを避ける
堅牢なストレージ・ソリューションではないので、 `hostPath`ストレージの使用は避けてください。 `hostPath`は動的なプロビジョニング、冗長性、あるいはノード間でポッドを移動する機能をサポートしません。

### hostNetworkを避ける
ポッドが `hostNetwork：true`で設定されている場合、そのようなポッドで実行されているアプリケーションは、ポッドが開始されたワーカーノードのネットワーク・インターフェースを直接見ることができます。これは、アプリケーションがホストマシンのすべてのネットワークインターフェースでアクセス可能になることを意味します。
これにより、2つのポッドが同じポートを使用することを妨げ、特定のノードのIPアドレスに依存することになります。
hostNetworkは、アプリケーションをクラスタの外部からアクセス可能にするための良い方法ではありません。 IBMは外部からアクセスするために `NodePort`または` Ingress`を使うことを提案しています。
ネットワークモニタやIngressコントローラのように、ホストレベルのネットワーキングに直接アクセスする必要があるチャートを作成しているのでなければ、IBMは `hostNetwork`を避けることを推奨します。

### リソースの使用量の文書化
チャートには、必要な最小のCPU、メモリ、ストレージのリソース、およびデフォルトで要求されるCPU、メモリ、およびストレージの量をREADME.mdで明確に文書化する必要があります。

### メータリング機能統合
IBM Cloud Privateメータリング・サービスは、実行中のワークロードを構成するコンテナ化されたコンポーネントによって`available`(利用可能)、`capped`(上限が設定されている)、および/または`used`(利用されている) 仮想プロセッサ・コアに基づいて、IBM Cloud Privateで実行されているコンテナの使用情報を収集します。

仮想コア情報は、IBM Cloud Privateクラスター内で稼働しているメータリング・デーモンによって自動的に収集されます。適切なメトリックが収集され、実行中のオファリングに起因するように、ワークロードはこのデーモンに対して自分自身を識別する必要があります。

メタデータは、計測目的で収集されたメトリクスと展開されたオファリングを関連付けるために使用されます。メータリング・サービスは、実行中のオファリングのメトリックを単純に測定し、UIを介して、そしてダウンロード可能なCSV形式のデータとして、過去の使用状況データをユーザーに提供します。

ワークロードは、ポッドのメタデータ・アノテーションを使用して、メーター・リーダーの製品ID、製品名、および製品バージョンを指定する必要があります。これは、特定の展開のためのHelmチャートのSpecTemplateセクションで定義されています。
    * 製品名(`productName`)は、人間が読むことができるオファリングの名称です。
    * 製品ID(`productID`)は、オファリングを一意に識別します(一意性を保証するためにあなたの会社または組織名で名前空間を付けてください)
    * 製品バージョン(`productVersion`)はオファリングのバージョンを指定します
     ```
     kind: Deployment
        spec:
          template:
             metadata:
               annotations:
                  productName: IBM Sample Chart
                  productID: com.ibm.chartscommunity.samplechart.0.1.2
                  productVersion: 0.1.2
      ```

### ロギング統合
IBM Cloud Privateノードは、標準出力および標準エラー・ストリームに書き込まれたログ・データを自動的に収集し、それを統合ロギング・サービス(Elasticsearch / Logstash / Kibana)に転送するようになっています。
ワークロード・コンテナーは、個別のログ・ファイルではなく、ログ・データをstdoutおよびstderrに書き込む必要があります。これにより、それらはIBM Cloud Privateロギング・サービスによって自動的に管理されます。<br>
ワークロードのチャートには関連するKibanaダッシュボードへのリンクをREADME.mdに含めることをお勧めします。これによりユーザーがダッシュボードダウンロードしてKibanaにインポートすることができます。

### モニタリング統合
ワークロードはデフォルトのIBM Cloud Privateモニタリング・サービス(Prometheus / Grafana)と統合することを推奨します。PrometheusメトリックスをKubernetesの「Service」で公開し、そのエンドポイントにアノテーションを付けてIBM Cloud Privateモニタリングサービスによって自動的に管理されるようにします。IBMは、個別に独自のPrometheusまたはGrafanaのインスタンスを用意するのではなく、製品プラットフォームの監視サービスと統合することをお勧めします。これにより、ユーザーは中心のインスタンスからすべてのデータを取得でき、オーバーヘッドを減らすこともできます。

  PrometheusエンドポイントをIBM Cloud Privateモニター・サービスに公開するには、以下の例に示すようにアノテーション `prometheus.io/scrape： 'true'`を使用してください。

  ```
    apiVersion: v1
    kind: Service
    metadata:
      annotations:
        prometheus.io/scrape: 'true'
      labels:
        app: {{ template "fullname" . }}
      name: {{ template "fullname" . }}-metrics
    spec:
      ports:
      - name: {{ .Values.service.name }}-metrics
        targetPort: 9157
        port: 9157
        protocol: TCP
      selector:
        app: {{ template "fullname" . }}
      type: ClusterIP
  ```
  個々のメトリックス名は、ワークロードの名前を前に付ける必要があります(例えば、 `ibmmq_object_mqput_bytes`)。

  ### ライセンスキーと価格
  チャートのデプロイまたは他の方法でワークロードを使用するためにライセンスキーが必要な場合は、チャートのREADME.mdの「前提条件」セクションに記載する必要があります。さらに、キーの入手方法に関する指示、および価格設定と試用に関する情報も、このステートメントと一緒に含めるかリンクして、チャートのインストールとワークロードの使用に必要なキーを容易に入手できるようにする必要があります。
