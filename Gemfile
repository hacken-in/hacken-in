source 'https://rubygems.org'

gem 'rails', '~> 4.0.3'
gem 'rake', '~> 10.1.1'

# Databases
gem 'mysql2', '~> 0.3.13'

# Memcache Store
# DO NOT UPGRADE THIS
# We need exactly this version, because
# newer versions can't connect to unix
# sockets. See here:
#
#  https://github.com/mperham/dalli/issues/229
#
gem 'dalli', '~> 1.1.5'

# Tags
gem 'acts-as-taggable-on', '~> 2.4.1'

# Statistics
gem 'chartkick', '~> 1.2.1'

# TODO: Remove
# This lib is used exactly ONCE in the admin interface
gem 'momentjs-rails', '~> 2.4.0'

# Assets
gem 'sass-rails', '~> 4.0.1'
gem 'coffee-script', '~> 2.2.0'
gem 'leaflet-rails', '~> 0.7.1'
gem 'uglifier', '~> 2.4.0'
gem 'jquery-rails', '~> 3.0.0'
gem 'foundation-rails', '5.0.2.0'

gem 'haml', '~> 4.0.4'
gem 'md_emoji', '~> 1.0.0'
gem 'redcarpet', '~> 3.0.0'

# Admin
# Attention: 0.6.0 has namespacing issues
# The '/' root tries to open a non existend
# dashboard controller
# TODO: Set this to the Ruby Gems version as soon as this is released
gem 'activeadmin', git: 'https://github.com/gregbell/active_admin', branch: 'master'

# Date Handling
gem 'ice_cube', '~> 0.11.1'
gem 'ri_cal', '~> 0.8.8'

# Authentication and Authorization
gem 'devise', '~> 3.2.0'
gem 'devise-i18n', '~> 0.10.3'
gem 'cancancan', '~> 1.7'
gem 'omniauth', '~> 1.1.3'
gem 'omniauth-github', '~> 1.1.0'
gem 'omniauth-twitter', '~> 1.0.1'

# Picture Upload
gem 'carrierwave', '~> 0.9.0'
gem 'mini_magick', '~> 3.7.0'

# Form Handling
gem 'simple_form', '~> 3.0.1'

# JavaScript runtime
gem 'execjs', '~> 2.0.2'
gem 'therubyracer', '~> 0.12.0'

# User Picture using Gravatar
gem 'gravatar_image_tag', '~> 1.2.0'

# Pagination
# Can't update to 0.15 for now, because ActiveAdmin
# is locked to this version
gem 'kaminari', '~> 0.15.1'

# For the auto follow script
gem 'twitter', '~> 5.5.1'

# Other dependencies
gem 'gabba', '~> 1.0.1'
gem 'geocoder', '~> 1.1.9'

# Nicer drop down boxes in the admin area
gem 'chosen-rails', '~> 1.1.0'

# Meetup API
gem 'ruby_meetup2', '~> 0.5.0'

group :development do
  # Manage locales, see http://www.localeapp.com/projects/5442
  gem 'localeapp'

  # Deployment
  gem 'capistrano', '~> 2.13.0'

  group :darwin do
    gem 'rb-fsevent', '~> 0.9.4'
    gem 'growl', '~> 1.0.3'
  end

  gem 'better_errors', '~> 1.1.0'
  gem 'binding_of_caller', '~> 0.7.1'

  # Faster test execution
  gem 'spring', '~> 1.1.2'
  gem 'spring-commands-rspec', '~> 1.0.1'

  # Guard
  gem 'guard', '~> 2.2.5'
  gem 'guard-rspec', '~> 4.2.2'
  gem 'guard-pow', '~> 2.0.0'
  gem 'guard-bundler', '~> 2.0.0'

  # Silence asset pipeline and make log usable again
  gem 'quiet_assets', '~> 1.0.2'

end

group :test, :development do
  gem 'database_cleaner', '1.2.0'
  gem 'rspec-rails',  '~> 3.0.0.beta1'
  gem 'factory_girl_rails', '~> 4.2'
  gem 'faker', '~> 1.2.0'
  gem 'coveralls', '~> 0.7.0'
  gem 'simplecov', '~> 0.8.2'
  gem 'brakeman', '~> 2.3.1'
  gem 'vcr', '~> 2.8.0'
  gem 'pry-rails'
end

group :test do
  gem 'webmock', '~> 1.17.3'
end

gem 'recaptcha', '0.3.5'

platform :rbx do
  gem 'rubysl', '~> 2.0.0'
  gem 'racc'
  group :test do
    gem 'rubysl-test-unit', require: false
    gem 'rubinius-coverage'
  end
end
