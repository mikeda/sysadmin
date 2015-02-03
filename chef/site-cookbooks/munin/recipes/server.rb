include_recipe 'httpd'

%w( munin munin-cgi ).each do |pkg|
  package pkg
end

cookbook_file '/etc/munin/munin.conf' do
  user  'root'
  group 'root'
  mode  00644
end

%w( munin.conf munin-cgi.conf ).each do |conf|
  cookbook_file "/etc/httpd/conf.d/#{conf}" do
    source "httpd/conf.d/#{conf}"
    notifies :restart, resources(:service => 'httpd')
  end
end
