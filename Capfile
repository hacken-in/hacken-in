# Load DSL and set up stages
require 'capistrano/setup'

# Include default deployment tasks
require 'capistrano/deploy'

SSHKit.config.output_verbosity = Logger::DEBUG

require 'capistrano/bundler'
require 'capistrano/rails/assets'
require "airbrussh/capistrano"
require "whenever/capistrano"

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
