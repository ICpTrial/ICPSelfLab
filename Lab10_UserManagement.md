# Lab10. ICPでのユーザー管理

ICPで admin ユーザー以外を追加するためには、LDAPとの連携が必要になります。
LDAPを通じてユーザーをICPに連携した上で、そのユーザーをチームに編成し、それぞれのユーザーのアクセス権限を設定します。

このLabでは、ICP環境とLDAPを連携させ、複数ユーザーで ICPを管理できるようにします。

## 前提

このハンズオンは、ICPがインストールされたあとであれば任意のタイミングで実施可能です。
ハンズオンのため便宜的に連携先のLDAPとしては、コンテナベースで提供される openldap を利用します。

所用時間は、およそ20分です。

## ICP HELMテンプレートの作成とインポート

1. openldap helmチャートの準備
  1. 以下のコマンドで、openldap の helmチャートを入手してください。
    ```
    git clone https://github.com/ibm-cloud-architecture/icp-openldap.git
    ```
  1. helmチャートをパッケージします。
    ```
    helm package icp-openldap
    Successfully packaged chart and saved it to: /work/icp-openldap-0.1.5.tgz
    ```
1. ICPのhelmレポジトリへの登録
  1. ICPにログインしていなければログインしてください
    ```
    # cloudctl login -a https://mycluster.icp:8443
    ```
  1. icp-openldap の HELMチャートをアップロードします。
    ```
    # cloudctl catalog load-helm-chart -archive /work/icp-openldap-0.1.5.tgz
    Helm チャートのロード中
    ロードされた Helm チャート

    チャートの同期
    同期が開始されました
    OK
    ```
   1. 以下のコマンドで icp-openldap のHELMチャートを導入します。
    ```
    # helm install icp-openldap-0.1.5.tgz --name openldap --namespace default --tls
    ```
   1.  
    
