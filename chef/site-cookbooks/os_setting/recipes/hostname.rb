hostname = node['automatic']['ipaddress']

bash 'set hostname' do
  code <<-EOC
    hoostname #{hostname}
    hostnamectl set-hostname #{hostname}
    test -f /etc/cloud/cloud.cfg && sed -i '/update_hostname/s/^/#/' /etc/cloud/cloud.cfg
    systemctl restart rsyslog
  EOC
  only_if { node['hostname'] != hostname }
end

ohai 'reload' do
  plugin 'hostname'
end
