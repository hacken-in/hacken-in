if Rails.application.secrets.key? :bugsnag_api_key
  Bugsnag.configure do |config|
    # See https://bugsnag.com/docs/notifiers/ruby#configuration
    # for all available configuration keys
    config.api_key = Rails.application.secrets.bugsnag_api_key

    config.release_stage = ENV['CLOUD_NAME'] == 'hacken-in-master' ? 'master' : 'production'
  end
end
