package 'munin-node'

service 'munin-node' do
  supports :restart => true
  action [ :enable, :start ]
end

cookbook_file '/etc/munin/munin-node.conf' do
  user  'root'
  group 'root'
  mode  00644
  notifies :restart, resources(:service => "munin-node")
end

delete_plugins = %w(
  df_inode entropy exim_mailqueue forks if_err_eth0
  fw_packets interrupts irqstats netstat
  ntp_kernel_err ntp_kernel_pll_freq ntp_kernel_pll_off ntp_offset ntp_states
  open_files open_inodes proc_pri
  sendmail_mailqueue sendmail_mailstats sendmail_mailtraffic
  uptime users
)

delete_plugins.each do |plugin|
  plugin_path = "/etc/munin/plugins/#{plugin}"
  link plugin_path do
    action :delete
    only_if { File.exists?(plugin_path) }
    notifies :restart, resources(:service => "munin-node")
  end
end
