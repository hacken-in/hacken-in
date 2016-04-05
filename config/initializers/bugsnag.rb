Bugsnag.configure do |config|
  config.api_key = Rails.application.secrets.bugsnag_api_key
  config.release_stage = Rails.configuration.x.release_stage
end
