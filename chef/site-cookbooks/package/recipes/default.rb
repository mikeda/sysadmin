node[:package][:groups].each do |group|
  bash "install #{group[:name]}" do
    code <<-EOC
      yum -y groupinstall #{group[:name]}
    EOC
    not_if "rpm -q #{group[:check]}"
  end
end

node[:package][:devels].each do |pkg|
  package pkg
end

node[:package][:tools].each do |pkg|
  package pkg
end
