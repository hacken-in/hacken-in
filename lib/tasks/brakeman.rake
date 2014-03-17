namespace :brakeman do
  EXCLUDED_CHECKS = [
    'CheckSessionSettings', # This is just for easy setup, on the server we have a different secret
    'CheckRender' # False positive which happens quite regularly according to the documentation
  ]

  desc "Check if there are no brakeman warnings"
  task :check do
    require 'brakeman'

    tracker = Brakeman.run app_path: ".", skip_checks: EXCLUDED_CHECKS

    fail 'Brakeman found errors. Run brakeman:report' unless tracker.warnings.empty?
  end

  desc "Give a brakeman report"
  task :report do
    require 'brakeman'

    Brakeman.run app_path: ".", print_report: true, skip_checks: EXCLUDED_CHECKS
  end
end
