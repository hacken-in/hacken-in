require "bundler/vlad"

set :application, "hcking"
set :deploy_to, "/home/hacking43451/hcking"
set :user, "hacking43451"
set :domain, "#{user}@hcking.de"
set :ssh_flags, ['-p 45672']
set :repository, 'git://github.com/bitboxer/hcking.git'

set :config_files, ['database.yml', 'newrelic.yml', 'initializers/secret_token.rb']

namespace :vlad do

  desc "Copy config files from shared/config to release dir"
  remote_task :copy_config_files, :roles => :app do
    config_files.each do |filename|
      run "cp #{shared_path}/config/#{filename} #{release_path}/config/#{filename}"
    end
  end

  desc "Make a call to the passenger to create a running instance"
  remote_task :call_passenger, :roles => :app do
    run "wget -O /tmp/bla.html http://hcking.de"
  end

  desc "Regenerate assets"
  remote_task :regenerate_assets, :roles => :app do
    run "cd #{release_path};RAILS_ENV=production bundle exec rake assets:precompile"
  end

end

