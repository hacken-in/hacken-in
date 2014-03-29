# -*- encoding : utf-8 -*-
require "bundler/capistrano"

# Settings
set :application, "hcking"
set :deploy_to, "/var/www/virtual/hacken/hacken_redesign"
set :user, "hacken"
set :config_files, ['database.yml',
  'initializers/secret_token.rb', 'initializers/devise.rb', 'initializers/recaptcha.rb',
  'omniauth.yml', 'twitter.yml']

# Git Repo
set :repository,  "git://github.com/hacken-in/website.git"
set :scm, :git
set :branch, "master"

set :use_sudo, false

# SSH Options
default_run_options[:pty] = true
ssh_options[:forward_agent] = true

# Servers
role :web, "crux.uberspace.de"
role :app, "crux.uberspace.de"
role :db,  "crux.uberspace.de", :primary => true

after "deploy:restart", "deploy:cleanup"

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, roles: :app, except: { no_release: true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
    run "wget -O /dev/null http://www.hacken.in"
  end

  task :symlink_config, roles: :app do
    run "ln -s #{shared_path}/uploads #{release_path}/public/uploads"
    config_files.each do |filename|
      run "cp #{shared_path}/config/#{filename} #{release_path}/config/#{filename}"
    end
  end
  after "deploy:finalize_update", "deploy:symlink_config"

end
