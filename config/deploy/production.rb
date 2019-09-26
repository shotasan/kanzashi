server '3.114.188.239', user: 'app', roles: %w{app db web}
set :ssh_options, keys: '/Users/shota/.ssh/id_rsa'
set :puma_conf, "#{shared_path}/config/puma.rb"