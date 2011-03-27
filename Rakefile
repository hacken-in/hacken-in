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
    Rake::Task["vlad:call_passenger"].invoke
  end

  task "vlad:deploy" => %w[
    vlad:update vlad:migrate vlad:bundle:install vlad:start_app vlad:cleanup
  ]
rescue LoadError
  # do nothing
end
