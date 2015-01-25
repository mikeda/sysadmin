default[:package][:groups] = [
  { name: 'Base', check: 'vim-enhanced' },
  { name: 'Development Tools', check: 'gcc' }
]

default[:package][:tools] = %w(
  dstat ftp lynx nmap
  telnet tmux tree
)

default[:package][:devels] = %w(
  curl-devel gdbm-devel httpd-devel
  libyaml-devel ncurses-devel openssl-devel
  readline-devel sqlite-devel zlib-devel
)
