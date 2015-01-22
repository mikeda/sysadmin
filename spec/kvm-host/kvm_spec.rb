require 'spec_helper'

describe package('libvirt') do
  it { should be_installed }
end

describe service('libvirtd') do
  it { should be_enabled }
  it { should be_running }
end
