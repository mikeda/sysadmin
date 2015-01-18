bash 'install Base and Development Tools' do
  code <<-EOC
    yum -y groupinstall Base 'Development Tools'
  EOC
  not_if 'rpm -q gcc'
end

node[:os_setting][:packages].each do |pkg|
  package pkg
end
