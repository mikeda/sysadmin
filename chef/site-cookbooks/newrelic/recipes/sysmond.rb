yum_repository 'newrelic' do
  description 'New Relic packages for Enterprise Linux 5 - $basearch'
  baseurl 'https://yum.newrelic.com/pub/newrelic/el5/$basearch'
  gpgcheck false
  action :create
end

package "newrelic-sysmond"

template "/etc/newrelic/nrsysmond.cfg" do
  owner "root"
  group "newrelic"
  mode "0640"
  notifies :restart, "service[newrelic-sysmond]"
end

service "newrelic-sysmond" do
  supports restart: true
  action [:enable, :start]
end
