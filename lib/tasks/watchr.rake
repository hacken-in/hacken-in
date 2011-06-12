desc "Run watchr"
task :watchr do
      sh %{bundle exec watchr config/watchr.rb}
end
