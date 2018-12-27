# Lab7. 独自のDockerイメージをHELMにパッケージング

このLabでは、Lab4.で利用した独自のWebSphere Libertyイメージをデプロイする際に利用した様々なKubernetesオブジェクトを、HELMにパッケージングします。


## 前提

所用時間は、およそ30分です。

## ハンズオン環境の確認

1. コマンド・プロンプトを起動します。

## LibertyイメージをICPのプライベート・レジストリーにPush(アップロード)

(参照)
[ICP KnowledgeCenter: イメージのプッシュおよびプル](https://www.ibm.com/support/knowledgecenter/ja/SSBS6K_3.1.0/manage_images/using_docker_cli.html)

1. Lab4で利用した yamlファイルが配置されている 作業ディレクトリに移動します。

1. `helm create <application Name> ` コマンドを利用して、HELMのパッケージの枠を作成します。

   ※ハンズオン環境には tree コマンドは導入されていませんが、treeコマンドで表示すると以下のような構成になっています。
   ご自身で確認されたい場合には、`apt install tree` コマンドで treeコマンドを導入して確認ください。
   ```
   $ tree mylibertyapp
    mylibertyapp
    ├── charts
    ├── Chart.yaml
    ├── templates
    │   ├── deployment.yaml
    │   ├── _helpers.tpl
    │   ├── ingress.yaml
    │   ├── NOTES.txt
    │   └── service.yaml
    └── values.yaml
   ```
  
1. まず Chart.yamlの 定義ファイルである Chartl.yaml を確認します。
  ```
  apiVersion: v1
  appVersion: "1.0"
  description: ~~A Helm chart for Kubernetes~~ HandsOn Application
  ^^A Helm chart for Kubernetes^^ 
  ~~A Helm chart for Kubernetes~~
  %7E%7EA Helm chart for Kubernetes%7E%7E
  name: mylibertyapp
  version: 0.1.0
  ```
  
  1. 指定された名前で Chart名が作成されていることを確認します。
  1. description を "Handson Application" に変更します。この変更がICPのどこに反映されるかあとで確認します。
  
1. 次に 実際のコンテナ(Pod)のデプロイを定義している Deployment を確認します。



