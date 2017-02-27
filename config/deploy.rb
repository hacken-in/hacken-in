lock "3.4.0"

set :user, "hacken"
set :application, "hacken-in"
set :repo_url, "https://github.com/hacken-in/website.git"
set :log_level, :info
set :linked_dirs, ["log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "public/uploads"]

set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }
set :deploy_to, "~/#{fetch(:application)}-#{fetch(:stage)}"

set :keep_releases, 5

server "dubhe.uberspace.de", user: fetch(:user), roles: [:app, :db]

namespace :deploy do
  task :restart do
    on roles(:app) do
      within release_path do
        execute "touch tmp/restart.txt"
      end
    end
  end

  task :migrate do
    on roles(:app) do
      within release_path do
        execute "cd #{release_path}; source ~/hacken-in-#{fetch(:stage)}.secrets; bundle exec rake db:migrate"
      end
    end
  end

  task :setup do
    on roles(:app) do
      info "Creating hacken.in environment symlinks"
      execute "ln -sf #{current_path}/infrastructure/uberspace/#{fetch(:stage)}/hacken-in-#{fetch(:stage)} ~/bin/"
      execute "cd #{release_path}; source ~/hacken-in-#{fetch(:stage)}.secrets; bundle exec rake uberspace:print_htaccess > /var/www/virtual/hacken/#{fetch(:vhost)}/.htaccess"
      execute "ln -snf /var/www/virtual/hacken/#{fetch(:vhost)} ~/hacken-in-#{fetch(:stage)}/shared/public"
    end
  end
end
after "deploy:updated", "deploy:migrate"
after "deploy:published", "deploy:restart"
after "deploy:published", "whenever:update_crontab"
