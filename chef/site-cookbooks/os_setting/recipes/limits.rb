cookbook_file '/etc/security/limits.conf' do
  user 'root'
  group 'root'
  mode 00644
end
