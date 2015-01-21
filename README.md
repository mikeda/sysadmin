sysadmin
==================

個人インフラの管理

* 対応プラットフォーム
  * KVM(自宅サーバ)
  * EC2
  * Vagrant
* CentOS7
* chef
* 操作ユーザはmikedaで統一

## 構築手順

### レポジトリの初期化

```
$ git clone git@github.com:mikeda/sysadmin.git
$ cd sysadmin
$ bundle install --path vendor/bundle
$ bundle exec berks vendor
```

### サーバ作成

#### AWS

```
$ export AWS_ACCESS_KEY_ID="XXXX"
$ export AWS_SECRET_ACCESS_KEY="XXXXXXXX"
$ bundle exec bin/ec2_create_instance.rb test05 ec2_default m3.large
```

引数はホスト名、config/aws.ymlで指定したrole、インスタンスサイズ。

インスタンス作成、共通のOS初期化処理以外にこのへんも実行。

* インスタンス、EBSのNameタグを設定
* EIPの取得とアサイン
* Route53にレコードを作成

### Vagrant

```
$ vim Vagrantfile
...
  config.vm.define :app02 do |node|
    node.vm.network :private_network, ip: '192.168.2.12'
  end
end
$ vagrant up app02
```

### KVMゲスト

```
$ ssh vm-host.home
$ sudo su -
# ~/bin/vm_create.sh test04 192.168.1.104 1 2048 5
```

### OS設定、MWセットアップ

chef-solo実行

```
$ vim chef/nodes/test05.mikeda.jp.json
{
  "run_list": [
    "role[default]"
  ],
  "automatic": {
    "ipaddress": "test05.mikeda.jp"
  }
}

$ bundle exec knife solo prepare test05.mikeda.jp.json
$ bundle exec knife solo cook test05.mikeda.jp.json
```
