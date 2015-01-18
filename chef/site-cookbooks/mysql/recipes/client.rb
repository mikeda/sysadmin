%w(
  mysql-community-client
  mysql-community-devel
).each do |pkg|
  package pkg do
    version node['mysql']['version']
  end
end
