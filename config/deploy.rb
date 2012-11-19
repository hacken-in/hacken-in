# -*- encoding : utf-8 -*-
require "bundler/capistrano"

# Settings
set :application, "droidboy"
set :deploy_to, "/var/www/virtual/droidboy/nerdhub"
set :user, "droidboy"

# Git Repo
set :repository,  "git://github.com/nerdhub/hcking.git"
set :scm, :git
set :branch, "master"

# SSH Options
default_run_options[:pty] = true
ssh_options[:forward_agent] = true

# Servers
role :web, "corvus.uberspace.de"
role :app, "corvus.uberspace.de"
role :db,  "corvus.uberspace.de", :primary => true

after "deploy:restart", "deploy:cleanup"

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    #ToDo: Bodo, hier müssen alle Configs rein, die sonst noch gesymlinkt werden müssen
  end
  after "deploy:finalize_update", "deploy:symlink_config"
end
