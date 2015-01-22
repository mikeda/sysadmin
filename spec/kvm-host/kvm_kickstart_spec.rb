require 'spec_helper'

describe package('httpd') do
  it { should be_installed }
end

describe service('httpd'), :if => os[:family] == 'redhat' do
  it { should be_enabled }
  it { should be_running }
end

describe port(80) do
  it { should be_listening }
end

describe file('/var/www/html/iso/CentOS-7.0-1406-x86_64-Minimal.iso') do
  it { should be_file }
end

describe file('/var/www/html/os/centos7') do
  it do
    should be_mounted.with(
      :device => '/var/www/html/iso/CentOS-7.0-1406-x86_64-Minimal.iso',
      :type => 'iso9660'
    )
  end
end

describe package('php') do
  it { should be_installed }
end

describe file('/root/bin/vm_create.sh') do
  it { should be_file }
end
