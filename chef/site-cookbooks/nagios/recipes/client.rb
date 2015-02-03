%w( nrpe nagios-plugins-all ).each do |pkg|
  package pkg
end

service 'nrpe' do
  supports restart: true, reload: true
  action [ :enable, :start ]
end

cookbook_file '/etc/nagios/nrpe.cfg' do
  source 'nrpe.cfg'
  mode 0644
  notifies :restart, resources(service: 'nrpe')
end
