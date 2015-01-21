package 'httpd'

directory '/var/log/httpd/' do
  mode 0755
end

%w(userdir.conf  welcome.conf).each do |conf|
  file "/etc/httpd/conf.d/#{conf}" do
    action :delete
  end
end

service 'httpd' do
  supports restart: true, reload: true
  action [ :enable, :start ]
end

cookbook_file '/etc/httpd/conf/httpd.conf' do
  owner  'root'
  group  'root'
  mode   0644
  notifies :restart, resources(service: 'httpd')
end
