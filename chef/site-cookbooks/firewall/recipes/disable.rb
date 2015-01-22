service 'firewalld' do
  action [ :stop, :disable ]
end
