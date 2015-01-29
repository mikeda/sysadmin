include_recipe 'nginx::default'

template '/etc/nginx/conf.d/redmine.conf' do
  owner  'root'
  group  'root'
  mode   00644
  notifies :reload, resources(:service => "nginx")
end
