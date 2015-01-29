package 'nginx'

service 'nginx' do
  supports restart: true, reload: true
  action [ :enable, :start ]
end

template '/etc/nginx/nginx.conf' do
  owner  'root'
  group  'root'
  mode   00644
  notifies :restart, resources(service: 'nginx')
end

%w(
  fastcgi.conf fastcgi.conf.default
  fastcgi_params fastcgi_params.default
  scgi_params scgi_params.default
  uwsgi_params uwsgi_params.default
  koi-utf koi-win win-utf
  conf.d/virtual.conf
).each do |file|
  file "/etc/nginx/#{file}" do
    action :delete
  end
end

directory '/var/log/nginx/' do
  mode 0755
end

