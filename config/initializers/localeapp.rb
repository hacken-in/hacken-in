# We only want to load localeapp if there is config file
if Rails.env.development? && File.exist?("config/localeapp.yml")
  require 'localeapp/rails'

  localeapp_config = YAML.load_file("config/localeapp.yml")

  Localeapp.configure do |config|
    config.api_key = localeapp_config["key"]
  end
end
