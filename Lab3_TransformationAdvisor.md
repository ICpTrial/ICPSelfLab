
# Lab1. ローカルPC上でのDockerの基本操作

このLabでは、ローカルPC上のDocker (Docker for WindowsやDocker for Mac) で、Apache httpdのイメージを使用して、Dockerの基礎を説明します。

## 前提

この　Labでは、下記の準備を前提としています。
- Docker for WindowsまたはDocker for Macの導入
- インターネットに接続できる環境

所用時間は、およそ30分です。

## Docker環境の確認

1. ハンズオン環境の確認
    1. コマンド・プロンプトを起動します。
    1. このLabの作業ディレクトリー (C:¥Handson¥Lab1) に移動します。このディレクトリーには、下記のファイルが事前に準備されています。
        - index.html : Apache httpd稼働確認用のhtmlファイル

1. Docker環境の確認
    1. コマンドプロンプトで、 `docker version` コマンドを入力します。Dockerエンジンのバージョンが表示されます。
        ```
        Yoshiki-no-MacBook-Air:Lab1 yoshiki$ docker version
        Client:
         Version:           18.06.1-ce
         API version:       1.38
         Go version:        go1.10.3
         Git commit:        e68fc7a
