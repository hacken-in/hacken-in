#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

include Rake::DSL

Hcking::Application.load_tasks

begin
  require 'vlad'
  Vlad.load :scm => :git

  task "vlad:copy_files" do
    Rake::Task["vlad:copy_config_files"].invoke
    Rake::Task["vlad:regenerate_assets"].invoke
  end

  task "vlad:deploy" => %w[
    vlad:update vlad:bundle:install vlad:copy_files vlad:migrate vlad:start_app vlad:call_passenger vlad:cleanup
  ]
rescue LoadError
  # do nothing
end
