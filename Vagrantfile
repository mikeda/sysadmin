# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = 'chef/centos-7.0'

  config.vm.provision 'shell', path: 'bin/useradd_mikeda.sh'

  config.vm.define :app01 do |node|
    node.vm.network :private_network, ip: '192.168.2.11'
    node.vm.network :forwarded_port, host: 8001, guest: 8000
  end

  config.vm.define :app02 do |node|
    node.vm.network :private_network, ip: '192.168.2.12'
  end
end
