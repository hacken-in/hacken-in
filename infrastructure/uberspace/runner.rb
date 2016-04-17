#!/usr/bin/env ruby

## Uberrunner 🏃
#
# This is a small wrapper around Unicorn, so we can utilise Uberspaces
# daemontools support for starting the app at boot time, and still be
# able to use Unicorns forking model that allows for zero downtime
# deploys.
#
# We intercept the HUP signal, let Unicorn respawn and give svc a
# proper process to manage.
#
##

require 'pathname'
require 'logger'
LOG = Logger.new(STDOUT)
APP_DIR = Pathname(__FILE__).dirname.parent.parent
PIDFILE = APP_DIR.join "tmp/pids/unicorn.pid"
UNICORN = "bundle exec unicorn_rails -c config/unicorn.rb -D -e '# #{ENV['APP_NAME']}'"

def pid
  File.exist?(PIDFILE) ? File.read(PIDFILE).to_i : nil
end

def start
  if pid
    LOG.warn "An instance is already running at #{pid}. Stopping it."
    stop
  end

  LOG.info "Starting hacken.in."
  system UNICORN
end

def restart
  Process.kill("USR2", pid)
end

def stop
  Process.kill("QUIT", pid) if pid
  exit 0
end

Signal.trap("HUP") { restart }
Signal.trap("TERM") { stop }

start

while true do
  sleep 10

  unless pid
    LOG.warn "Unicorn is not up. Will try one more time."
    sleep 10
    unless pid
      LOG.error "Unicorn is still down. Will stop now."
      stop
    end
  end

  LOG.info "Unicorn is up and running with pid #{pid}."
end

LOG.error "Sorry. Could not start Unicorn. Please check the log files."
