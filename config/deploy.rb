set :application, "droidboy"
set :deploy_to, "/var/www/virtual/droidboy/nerdhub"
set :user, "droidboy"
set :domain, "#{user}@corvus.uberspace.de"
set :repository,  "git://github.com/nerdhub/hcking.git"
set :scm, :git

role :web, "droidboy"
role :app, "droidboy"
role :db,  "droidboy", :primary => true

after "deploy:restart", "deploy:cleanup"

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
