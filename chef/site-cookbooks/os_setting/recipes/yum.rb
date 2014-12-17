cookbook_file '/etc/yum.repos.d/epel.repo' do
  user 'root'
  group 'root'
  mode 00644
end
