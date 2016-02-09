lock '3.4.0'

set :application, 'hacken-in'
set :repo_url, 'https://github.com/hacken-in/website.git'

set :user, 'hacken'
set :log_level, :info
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

set :keep_releases, 5

namespace :deploy do
  after :restart, :clear_cache do
    on roles(:web) do
      run "svc -h svc -h ~/service/hacken-in-#{fetch(:stage)"
    end
  end
end
