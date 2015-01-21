include_recipe 'httpd'

iso_file = 'CentOS-7.0-1406-x86_64-Minimal.iso'

directory '/var/www/html/iso'

remote_file "/var/www/html/iso/#{iso_file}" do
  source "http://ftp.riken.jp/Linux/centos/7/isos/x86_64/#{iso_file}"
  action :create_if_missing
end

directory '/var/www/html/os'
directory '/var/www/html/os/centos7'

mount '/var/www/html/os/centos7' do
  device "/var/www/html/iso/#{iso_file}"
  action [ :mount, :enable ]
end

package 'php'

remote_directory '/var/www/html/ks' do
  source 'ks'
end

directory '/root/bin'
cookbook_file '/root/bin/vm_create.sh' do
  mode 0744
end
