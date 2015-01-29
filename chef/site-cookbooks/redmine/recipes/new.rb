# 初回クリーンインストール用

include_recipe 'redmine::default'

version = '2.6.1'
tarball_path = "/usr/local/src/redmine-#{version}.tar.gz"
install_path = '/var/www/redmine'

bash 'create redmine database' do
  code <<-EOC
  EOC
  action :nothing
end

remote_file tarball_path do
  source "http://www.redmine.org/releases/redmine-#{version}.tar.gz"
  mode 00755
  action :create_if_missing
end

bash 'extract redmine' do
  user 'root'
  cwd '/tmp'
  code <<-EOC
    tar xzf #{tarball_path}
    /bin/mv redmine-#{version} #{install_path}
    cd #{install_path}
  EOC
  creates install_path
end

cookbook_file "#{install_path}/config/database.yml"
cookbook_file "#{install_path}/config/configuration.yml"
cookbook_file "#{install_path}/config/unicorn.rb"

bash 'setup redmine' do
  user 'root'
  cwd install_path
  code <<-EOC
    mysql -uroot -e "create database redmine default character set utf8;"
    mysql -uroot -e "grant all on redmine.* to redmine@localhost identified by 'redminepass';"

    echo 'gem "unicorn"' >> Gemfile
    bundle install --path vendor/bundle --without development test

    bundle exec rake generate_secret_token
    RAILS_ENV=production bundle exec rake db:migrate

    chown -R redmine.redmine #{install_path}
  EOC
  creates "#{install_path}/Gemfile.lock"
end
