lock "3.4.0"

set :user, "hacken"
set :application, "hacken-in"
set :repo_url, "https://github.com/hacken-in/website.git"
set :log_level, :info
set :linked_dirs, ["log", "tmp/pids", "tmp/cache", "tmp/sockets", "vendor/bundle", "public/system", "public/uploads"]

set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }
set :deploy_to, "~/#{fetch(:application)}-#{fetch(:stage)}"

set :keep_releases, 5

server "dubhe.uberspace.de", user: fetch(:user), roles: [:app, :db]

namespace :deploy do
  task :restart do
    on roles(:app) do
      execute "svc -h svc -h ~/service/hacken-in-#{fetch(:stage)}"
    end
  end
end

after "deploy:published", "deploy:restart"
after "deploy:published", "whenever:update_crontab"
