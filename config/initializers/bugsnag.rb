Bugsnag.configure do |config|
  config.api_key = Rails.application.secrets.bugsnag_api_key
  config.release_stage = ENV['CLOUD_NAME'] == 'hacken-in-master' ? 'master' : 'production'
end
