# OUT OF DATE, NEEDS UPDATING FOR DRAGON RELEASE

# Catapultサービスの起動

このリポジトリには起動と設定スクリプトが含まれていて、開発者が自分用のCatapult Serviceを使って素早く作業を開始することを可能にします。開発者は、できるだけ簡単かつ迅速に、この設定を実行して1分以内にはサーバーを起動してトランザクションを受取る準備をすることができ、サーバーの設定ではなく、開発作業に専念できることを目的としています。

注)この起動設定は、学習及び開発用途が目的であり、本番環境でのCatapultインスタンスの運用を想定していません。

私たちは、dockerイメージをパッケージングと配布の仕組みとして利用しています。起動スクリプト類は、ディスク上にファイルを準備し、docker-composeで必要なコンテナセットを起動し、サーバーが正しく起動するようにします。

## 環境の依存関係

必要な依存関係は、リポジトリをcloneするためのgitと、docker/docker-composeのみです。もし既にdockerのツールをインストールしていなければ、以下のdockerコミュニティのWebサイトから入手できます。

[Docker インストール概要](https://docs.docker.com/install/#server)

[Docker Compose インストール概要](https://docs.docker.com/compose/install/#install-compose)

## インストールと起動手順

1. `git clone git@github.com:tech-bureau/catapult-service-bootstrap.git`
2. `cd catapult-service-bootstrap`
3. `docker-compose up`

dockerのイントール手順を正しく実行し、docker/docker-composeがインストールされていれば、dockerが初回にコンテナイメージをダウンロードし、起動設定を実行します。成功すれば、Catapult Serverが起動し、ログが以下のようにスクロールを開始することが確認できます。

```
api-node-0_1              | 2018-05-18 18:52:11.888098 0x00007f24efa20700: <debug> (src::NetworkHeightService.cpp@45) network chain height increased from 120 to 121
peer-node-1_1             | 2018-05-18 18:52:12.068932 0x00007fe59221c700: <debug> (src::NetworkHeightService.cpp@45) network chain height increased from 120 to 121
peer-node-0_1             | 2018-05-18 18:52:12.477647 0x00007f35d4de4700: <debug> (src::NetworkHeightService.cpp@45) network chain height increased from 120 to 121
```

起動していることを確認するには、curlでブロック情報を取得するリクエストを投げてみます: `curl localhost:3000/block/1`

サーバーを停止するには、`Ctrl+c`を押してフォアグラウンドのdockerプロセスをkillまたは停止します。

## キーの設定

起動スクリプトは最初のキー生成と設定を行います。初回実行後、public/privateキーのペアが2組のファイルに保存されます。以下のディレクトリで、設定に使用されたキーの詳細を確認することができます。

```
ubuntu@catapult:~/catapult$ cd  build/generated-addresses/
ubuntu@catapult:~/catapult/build/generated-addresses$ ls
addresses.yaml  raw-addresses.txt  README.md
```

`raw-addresses.txt`ファイルは、Catapultアドレスユーティリティを利用して、docker-composeの実行時に生成されたアドレスです。

`addresses.yaml`ファイルは、`raw-addresses.txt`から生成されたアドレスですが、yaml形式でフォーマットされ、Catapult ノードやハーベスターキー向けの違う役割があります。このyamlファイルはCatapult起動時に使用される設定のインプットになります。

注)yamlのアドレスは'nemesis_addresses'です。nemesisブロック生成時に、テスト用xemが割り当てられます。

## Starting as a Background Process

上記の初期セットアップ手順では、Catapult Serverをフォアグラウンドでインストール及び起動しましたが、開発中はサーバをバックグラウンドで実行できると便利です。 これを行うには、 `catapult-server-bootstrap`ディレクトリに移動して` docker-compose up -d`を実行します。

`docker-compose up`コマンドのより詳しい情報は、dockerコミュニティのドキュメントを参照して下さい。

[Docker Compose Up コマンド概要](https://docs.docker.com/compose/reference/up/)

## Catapult Serverのリセット

Catapultサービスは、必要に応じて開始/停止できます。 毎回起動時、前回中断した所から開始します。

もしサービスの状態が不正になったり、初期化して再開したい場合は、bootstrap tool で簡単にできます。スクラッチ状態にリセットするには、

1. 実行中のCatapult Serviceを停止します(フォアグラウンドで実行している場合はCtrl+Cを使用し、バックグラウンドで実行している場合はリポジトリディレクトリに移動して`docker-compose down`を実行します)

2. 提供されているクリーンアップスクリプトのいずれかを実行します。

- `./clean-data`を実行すると、設定と生成されたキーは保持されますが、ブロックチェーンとキャッシュのデータはすべて削除されます。 再起動時、Catapultは初期化状態で起動します。

- `./clean-all`を実行すると、データに加えて、生成されたキーとキーから生成された設定が削除されます。 このスクリプトを実行した後は、開発中のアプリケーションやスクリプトで、build/generated-addresses /ディレクトリにある新しいキーを使用する必要があります。

## 既知の問題

Catapultのキャッシュとクエリエンジンは、mongodbを使用しています。 一部のdocker環境では、最新のストレージエンジンに関する既知の問題がいくつかあります。 起動時にmongoの `wiredtiger`エラーが発生した場合に使用するバックアップのdockerの構成ファイルを準備しています。 バックアップのファイルを使用するには、次のコマンドを実行します。

`docker-compose -f docker-compose-mmapv1.yml up`
