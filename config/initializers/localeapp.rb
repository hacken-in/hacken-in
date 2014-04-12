# If you don't have the localeapp api key, you can simple deactivate
# localeapp and remove the complete code in this file :)
if Rails.env.development? && File.exist?("config/localeapp.yml")
  require 'localeapp/rails'

  localeapp_config = YAML.load_file("config/localeapp.yml")

  Localeapp.configure do |config|
    config.api_key = localeapp_config["key"]
  end
end
