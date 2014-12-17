bash 'install Development Tools' do
  code <<-EOC
    yum -y groupinstall 'Development Tools' 'Development Libraries'
  EOC
  not_if 'rpm -q gcc'
end

node[:os_setting][:packages].each do |pkg|
  package pkg
end
