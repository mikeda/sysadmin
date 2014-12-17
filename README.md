sysadmin
==================

個人のAWS管理用のスクリプトとかchefのcookbookとか

## ポリシー的なもの

* シングルAZ
* 1つのグローバルサブネット。セキュリティはセキュリティグループで担保
* グローバルIPで直接SSH接続する
  * EC2インスタンスにEIPをアタッチする
  * 外部DNSにホストごとのDNSレコードを設定
* OSはAmazonLinuxのみ対応

## EC2インスタンス構築手順

#### レポジトリをclone

```
$ git clone git@github.com:mikeda/sysadmin.git
$ cd sysadmin
$ bundle install --path vendor/bundle
```

#### AWS SDKを使うためのキー設定

```
$ export AWS_ACCESS_KEY_ID="XXXX"
$ export AWS_SECRET_ACCESS_KEY="XXXXXXXX"
```

#### インスタンス作成

スクリプトでインスタンス作成。
引数はホスト名、config/aws.ymlで指定したrole、インスタンスサイズ。

```
$ bundle exec bin/ec2_create_instance.rb test05 ec2_default m3.large
Launching instance i-4321145a, status: pending
Launching instance i-4321145a, status: pending
Launching instance i-4321145a, status: pending
Launching instance i-4321145a, status: pending
Launching instance i-4321145a, status: pending
associated EIP : 54.65.98.31
create DNS record : test05.mikeda.jp.
```

内部では以下を実行しています。

* インスタンス作成
* OSの初期設定(hostname、Timezone)
* インスタンス、EBSのNameタグを設定
* EIPの取得とアサイン
* Route53にレコードを作成

#### chef-soloでOS/MWセットアップ

node定義を作成

```
$ vim chef/nodes/test05.mikeda.jp.json
{
  "run_list": [
    "role[default]"
  ]
}
```

chef-solo実行

```
# chef-soloインストール
$ bundle exec knife solo prepare test05.mikeda.jp.json

# chef-solo実行
$ bundle exec knife solo cook test05.mikeda.jp.json
```


#### 必要であればインスタンスサイズを調整

構築に時間かかる場合は大きめで作ってあとで小さくする。よく忘れてプチAWS破産する。

```
$ bundle exec bin/ec2_change_instance_type.rb test05 t2.micro
```
