sysadmin
==================

個人のAWS管理用のスクリプトとかchefのcookbookとか


* 対応プラットフォーム
  * 物理サーバ(KVMホスト)
  * KVMゲスト
  * EC2
  * Vagrant
* CentOS7
* chef

## 構築手順

### レポジトリのcloneと、bundler、berkshelfのセットアップ

```
$ git clone git@github.com:mikeda/sysadmin.git
$ cd sysadmin
$ bundle install --path vendor/bundle
$ bundle exec berks vendor
```

### サーバ作成

#### AWS

スクリプトでインスタンス作成。
引数はホスト名、config/aws.ymlで指定したrole、インスタンスサイズ。

```
$ export AWS_ACCESS_KEY_ID="XXXX"
$ export AWS_SECRET_ACCESS_KEY="XXXXXXXX"
$ bundle exec bin/ec2_create_instance.rb test05 ec2_default m3.large
```

内部では以下を実行

* インスタンス作成
* OSの初期設定(hostname、Timezone)
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

chefのnode定義を作成

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
