# -*- encoding : utf-8 -*-
require "bundler/capistrano"

# Settings
set :application, "hcking"
set :deploy_to, "/var/www/virtual/hacken/hcking"
set :user, "hacken"
set :config_files, ['database.yml',
  'initializers/secret_token.rb', 'initializers/devise.rb', 'initializers/recaptcha.rb',
  'omniauth.yml']

# Git Repo
set :repository,  "git://github.com/hcking/hcking.git"
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

  namespace :assets do

    # Check for changes in assets dir and only precompile if there are any
    task :precompile, roles: :app, except: { no_release: true } do
      # Check if assets have changed. If not, don't run the precompile task - it takes a long time.
      force_compile = false
      changed_asset_count = 0
      begin
        from = source.next_revision(current_revision)
        asset_locations = 'app/assets/ lib/assets vendor/assets'
        changed_asset_count = capture("cd #{latest_release} && #{source.local.log(from)} #{asset_locations} | wc -l").to_i
      rescue Exception => e
        logger.info "Error: #{e}, forcing precompile"
        force_compile = false
      end
      if changed_asset_count > 0 || force_compile
        logger.info "#{changed_asset_count} assets have changed. Pre-compiling"
        run %Q{cd #{latest_release} && bundle exec rake RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
      else
        logger.info "#{changed_asset_count} assets have changed. Skipping asset pre-compilation"
      end
    end

  end
end
