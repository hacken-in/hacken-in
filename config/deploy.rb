lock '3.4.0'

set :application, 'hacken-in'
set :repo_url, 'https://github.com/hacken-in/website.git'

set :user, 'hacken'
set :log_level, :info

set :linked_dirs, ['log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads']
set :whenever_roles, ->{ :app }
set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

set :keep_releases, 5

namespace :deploy do
  task :restart do
    on roles(:app) do
      execute "svc -h svc -h ~/service/hacken-in-#{fetch(:stage)}"
    end
  end
end

after 'deploy:published', 'deploy:restart'
