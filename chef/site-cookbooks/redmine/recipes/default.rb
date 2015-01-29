include_recipe 'mysql::server'
include_recipe 'imagemagick'
package 'ipa-pgothic-fonts'

user 'redmine'

if node['redmine']['new']
  include_recipe 'redmine::new'
end

cookbook_file '/etc/systemd/system/redmine-unicorn.service'

service 'redmine-unicorn' do
  action [ :start, :enable ]
end
