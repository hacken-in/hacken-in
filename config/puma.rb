RAILS_ENV = ENV.fetch("RAILS_ENV") { "development" }

threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }.to_i
threads threads_count, threads_count

rackup DefaultRackup

port        ENV.fetch("PUMA_PORT") { 3000 }
environment RAILS_ENV

# Specifies the number of `workers` to boot in clustered mode.
# Workers are forked webserver processes. If using threads and workers together
# the concurrency of the application would be max `threads` * `workers`.
# Workers do not work on JRuby or Windows (both of which do not support
# processes).
#
workers ENV.fetch("WEB_CONCURRENCY") { 2 }

# Use the `preload_app!` method when specifying a `workers` number.
# This directive tells Puma to first boot the application and load code
# before forking the application. This takes advantage of Copy On Write
# process behavior so workers use less memory. If you use this option
# you need to make sure to reconnect any threads in the `on_worker_boot`
# block.
#
preload_app!

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart

on_worker_boot do
  # worker specific setup
  ActiveRecord::Base.establish_connection
end

# Log output: stdout, stderr, append?
stdout_redirect 'log/puma.stdout.log', 'log/puma.stderr.log', true

# Tag Puma in the process list
tag "hacken-in-#{RAILS_ENV}"
