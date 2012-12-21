# -*- encoding : utf-8 -*-
require "bundler/capistrano"

# Settings
set :application, "droidboy"
set :deploy_to, "/var/www/virtual/droidboy/nerdhub"
set :user, "droidboy"
set :config_files, ['database.yml', 'newrelic.yml', 'initializers/secret_token.rb', 'omniauth.yml']

# Git Repo
set :repository,  "git://github.com/nerdhub/hcking.git"
set :scm, :git
set :branch, "master"

set :use_sudo, false

# SSH Options
default_run_options[:pty] = true
ssh_options[:forward_agent] = true

# Servers
role :web, "corvus.uberspace.de"
role :app, "corvus.uberspace.de"
role :db,  "corvus.uberspace.de", :primary => true

after "deploy:restart", "deploy:cleanup"

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
    run "wget -O /dev/null http://www.nerdhub.de"
  end

  task :symlink_config, roles: :app do
    run "ln -s #{shared_path}/uploads #{release_path}/public/uploads"
    config_files.each do |filename|
      run "cp #{shared_path}/config/#{filename} #{release_path}/config/#{filename}"
    end
  end
  after "deploy:finalize_update", "deploy:symlink_config"

  namespace :assets do

    # Check for changes in assets dir and only precompile if there are any
    task :precompile, :roles => :web, :except => { :no_release => true } do
      from = source.next_revision(current_revision)
      if capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
        run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
      else
        logger.info "Skipping asset pre-compilation because there were no asset changes"
      end
    end

  end
end
