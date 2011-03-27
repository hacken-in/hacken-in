require "bundler/vlad"

set :application, "hcking"
set :deploy_to, "/home/hacking43451/hcking"
set :user, "hacking43451"
set :domain, "#{user}@hcking.de"
set :ssh_flags, ['-p 45672']
set :repository, '~/hcking.git'

set :config_files, ['database.yml', 'newrelic.yml']

namespace :vlad do

  desc "Copy config files from shared/config to release dir"
  remote_task :copy_config_files, :roles => :app do
    config_files.each do |filename|
      run "cp #{shared_path}/config/#{filename} #{release_path}/config/#{filename}"
    end
  end

end
