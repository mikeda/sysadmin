include_recipe 'httpd'

%w(gd-devel nagios nagios-plugins-all nagios-plugins-nrpe).each do |pkg|
  package pkg
end

service 'nagios' do
  supports restart: true, reload: true
  action [ :enable, :start ]
end

%w(localhost.cfg printer.cfg switch.cfg windows.cfg).each do |cfg|
  file "/etc/nagios/objects/#{cfg}" do
    action :delete
  end
end

cookbook_file '/etc/nagios/nagios.cfg' do
  notifies :restart, resources(service: 'nagios')
end

%w(commands.cfg hostgroups.cfg hosts.cfg services.cfg).each do |cfg|
  cookbook_file "/etc/nagios/objects/#{cfg}" do
    source "objects/#{cfg}"
    mode 0644
    notifies :restart, resources(service: 'nagios')
  end
end
