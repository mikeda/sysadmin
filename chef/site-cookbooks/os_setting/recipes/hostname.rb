fqdn = node['automatic']['ipaddress']

ohai 'reload_hostname' do
  plugin 'hostname'
  action :nothing
end

bash 'set hostname' do
  code <<-EOC
    hostname #{fqdn}
    hostnamectl set-hostname #{fqdn}
    test -f /etc/cloud/cloud.cfg && sed -i '/update_hostname/s/^/#/' /etc/cloud/cloud.cfg
    systemctl restart rsyslog
  EOC
  only_if { node['fqdn'] != fqdn }
  notifies :reload, "ohai[reload_hostname]", :immediately
end
