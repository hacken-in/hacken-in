root = "/var/www/virtual/droidboy/nerdhub"
working_directory "#{root}/current/"
pid "#{root}/shared/pids/unicorn.pid"
stderr_path "#{root}/shared/log/unicorn.log"
stdout_path "#{root}/shared/log/unicorn.log"

listen "12341"
worker_processes 2

# nuke workers after 30 seconds instead of 60 seconds (the default)
timeout 30
