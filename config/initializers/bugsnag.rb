if Rails.application.secrets.key? :bugsnag_api_key
  Bugsnag.configure do |config|
    config.api_key = Rails.application.secrets.bugsnag_api_key
  end
end
