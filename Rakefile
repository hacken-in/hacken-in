# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

Hcking::Application.load_tasks

begin
  require 'vlad'
  Vlad.load :scm => :git

  task "vlad:update" do
    Rake::Task["vlad:copy_config_files"].invoke
  end

  task "vlad:release" => %w[
    vlad:update vlad:migrate vlad:bundle:install vlad:migrate barista:brew vlad:start_app vlad:call_passenger vlad:cleanup
  ]
rescue LoadError
  # do nothing
end
