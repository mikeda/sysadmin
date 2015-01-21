%w(libvirt qemu-kvm libguestfs virt-install).each do |pkg|
  package pkg
end

service 'libvirtd' do
  action [ :enable, :start ]
end
