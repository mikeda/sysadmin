%w(
  mysql-community-client
  mysql-community-devel
  mysql-community-libs-compat
).each do |pkg|
  package pkg do
    version node['mysql']['version']
  end
end
