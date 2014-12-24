package 'mysql-community-server' do
  version node['mysql']['version']
end

template '/etc/my.cnf' do
  source 'my.cnf.erb'
  owner  'mysql'
  group  'mysql'
  mode   00644
  variables({
    :server_id => sprintf('%d%03d%03d', *node[:ipaddress].split('.')[1..3])
  })
end

service 'mysqld' do
  action [ :enable, :start ]
end
