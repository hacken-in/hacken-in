require "bundler/vlad"

set :application, "droidboy"
set :deploy_to, "/home/droidboy/nerdhub"
set :user, "droidboy"
set :domain, "#{user}@corvus.uberspace.de"
set :repository, 'git://github.com/nerdhub/hcking.git'

set :config_files, ['database.yml', 'newrelic.yml', 'initializers/secret_token.rb']

namespace :vlad do

  desc "Copy config files from shared/config to release dir"
  remote_task :copy_config_files, roles: :app do
    config_files.each do |filename|
      run "cp #{shared_path}/config/#{filename} #{release_path}/config/#{filename}"
    end
    run "ln -s #{shared_path}/uploads #{release_path}/public/uploads"
  end

  desc "Make a call to the passenger to create a running instance"
  remote_task :call_passenger, roles: :app do
    run "wget -O ~/test.html http://hcking.de;rm ~/test.html"
  end

  desc "Regenerate assets"
  remote_task :regenerate_assets, roles: :app do
    run "cd #{release_path};RAILS_ENV=production bundle exec rake assets:precompile"
  end

end

