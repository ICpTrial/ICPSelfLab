# Lab7. 独自のDockerイメージをHELMにパッケージング

このLabでは、Lab4.で利用した独自のWebSphere Libertyイメージをデプロイする際に利用した様々なKubernetesオブジェクトを、HELMにパッケージングします。


## 前提

所用時間は、およそ30分です。

## ハンズオン環境の確認

1. コマンド・プロンプトを起動します。

## LibertyイメージをICPの


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
  
1. まず Chart.yamlの 定義ファイルである Chartl.yaml を、viエディターで開いて確認します。
  ```
  apiVersion: v1
  appVersion: "1.0"
  description: A Helm chart for Kubernetes  ###ここを変更###
  name: mylibertyapp
  version: 0.1.0
  ```
  
  1. 指定された名前で Chart名が作成されていることを確認します。
  1. description を "Handson Application" に変更します。この変更がICPのどこに反映されるかあとで確認します。
  
1. 次に 実際のコンテナ(Pod)のデプロイを定義している Deployment を確認します。<br>
　 templatesディレクトリ下の deployment.yaml ファイルをviエディタで開きます。必要に応じて、先ほどのLab4 で利用したファイルを開いて確認してみてください。<br>
  
  1. このテンプレートの中で、{{ }} でくくられているところは変数です。
  
      |変数|参照箇所 |  
      |----|----|
      |{{tempate }} | 作業ディレクトリにある _helpers.tpl を利用して決まります |
      |{{.Release.xxx}} |実行時に指定するインスタンスの値で置き換えられます |
      |{{.Values.xxx}} |values.yamlで定義された変数に置き換えられます |
   
  1. 先ほどのLiberty コンテンツに合わせて、コンテナ側のListenポートを 80 から 9080に変更します。<br>
     また、生死監視や レディネス監視に用いる URIもアプリケーションのコンテキスト・ルート /Sum に置き換えます
    
  ```
  apiVersion: apps/v1beta2
  kind: Deployment
  metadata:
    name: {{ template "mylibertyapp.fullname" . }}
    labels:
      app: {{ template "mylibertyapp.name" . }}
      chart: {{ template "mylibertyapp.chart" . }}
      release: {{ .Release.Name }}
      heritage: {{ .Release.Service }}
  spec:
    replicas: {{ .Values.replicaCount }}
    selector:
      matchLabels:
        app: {{ template "mylibertyapp.name" . }}
        release: {{ .Release.Name }}
    template:
      metadata:
        labels:
          app: {{ template "mylibertyapp.name" . }}
          release: {{ .Release.Name }}
      spec:
        containers:
          - name: {{ .Chart.Name }}
            image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
            imagePullPolicy: {{ .Values.image.pullPolicy }}
            ports:
              - name: http
                containerPort: 80  ###ここを変更###
                protocol: TCP
            livenessProbe:
              httpGet:
                path: /      ###ここを変更###
                port: http
            readinessProbe:
              httpGet:
                path: /      ###ここを変更###
                port: http
            resources:
  {{ toYaml .Values.resources | indent 12 }}
      {{- with .Values.nodeSelector }}
        nodeSelector:
  {{ toYaml . | indent 8 }}
      {{- end }}
      {{- with .Values.affinity }}
        affinity:
  {{ toYaml . | indent 8 }}
      {{- end }}
      {{- with .Values.tolerations }}
        tolerations:
  {{ toYaml . | indent 8 }}
      {{- end }}
  ```



