install_dir  = node[:rbenv][:install_dir]

directory install_dir do
  mode  00755
end

git install_dir do
  repository 'git://github.com/sstephenson/rbenv.git'
  reference 'master'
  revision '7e0e85bdda092d94aef0374af720682c6ea8999d'
  action :checkout
end

directory "#{install_dir}/plugins/" do
  mode  00755
end

git "#{install_dir}/plugins/ruby-build" do
  repository 'git://github.com/sstephenson/ruby-build.git'
  reference 'master'
  revision '95373b462cf4e218dd863bd43dbf6f08974c4a4a'
  action :checkout
end

template '/etc/profile.d/rbenv.sh' do
  owner  'root'
  group  'root'
  mode   0755
end

node[:rbenv][:versions].each do |version|
  bash "install rbenv ruby #{version}" do
    code <<-EOC
      . /etc/profile.d/rbenv.sh
      rbenv install #{version}
    EOC

    not_if <<-EOC
      . /etc/profile.d/rbenv.sh
      rbenv versions | grep -Fw #{version}
    EOC
  end

  node[:rbenv][:gems].each do |gem|
    gem_package gem do
      gem_binary "#{install_dir}/versions/#{version}/bin/gem"
    end
  end
end

bash 'rbenv global' do
  code <<-EOC
    . /etc/profile.d/rbenv.sh
    rbenv global #{node[:rbenv][:global_version]}
  EOC

  not_if <<-EOC
    . /etc/profile.d/rbenv.sh
    rbenv global | grep -Fw #{node[:rbenv][:global_version]}
  EOC
end
