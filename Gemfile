# coding: utf-8
source 'https://rubygems.org'
ruby '2.2.4'

gem 'rails', '~> 4.2.5.1'
gem 'rake', '~> 10.3.2'

gem 'unicorn', '~> 5.0.1'
# Databases
gem 'pg', '~> 0.17.1'

# Tags
gem 'acts-as-taggable-on', '~> 3.5.0'

# Statistics
gem 'chartkick', '~> 1.3.2'

# TODO: Remove
# This lib is used exactly ONCE in the admin interface
gem 'momentjs-rails', '~> 2.4.0'

# Assets
gem 'sass-rails', '~> 4.0.3'
gem 'coffee-script', '~> 2.2.0'
gem 'leaflet-rails', '~> 0.7.3'
gem 'uglifier', '~> 2.5.1'
gem 'jquery-rails', '~> 3.1.1'
gem 'jquery-ui-rails', '~> 5.0.3'
gem 'foundation-rails', '5.4.5.0'
gem 'font-awesome-rails', '~> 4.1.0.0'

gem 'haml', '~> 4.0.4'
gem 'md_emoji', '~> 1.0.0'
gem 'redcarpet', '~> 3.1.2'

# Admin
gem 'activeadmin', '~> 1.0.0.pre2'
gem 'ahoy_matey'
gem 'groupdate'

# Date Handling
gem 'ice_cube', '~> 0.11.1'
gem 'icalendar', '~> 1.5.2'

# Recurring Tasks
gem 'whenever', '~> 0.9.4'

# Authentication and Authorization
gem 'devise', '~> 3.5.6'
gem 'devise-i18n', '~> 0.10.3'
gem 'cancancan', '~> 1.8.4'
gem 'omniauth', '~> 1.1.3'
gem 'omniauth-github', '~> 1.1.0'
gem 'omniauth-twitter', '~> 1.0.1'

# Picture Upload
gem 'carrierwave', '~> 0.10.0'
gem 'mini_magick', '~> 3.7.0'

# Form Handling
gem 'simple_form', '~> 3.0.2'

# JavaScript runtime
gem 'execjs', '~> 2.2.1'
gem 'therubyracer', '~> 0.12.0'

# User Picture using Gravatar
gem 'gravatar_image_tag', '~> 1.2.0'

# For the auto follow script
gem 'twitter', '~> 5.6.0'

# Include some generic language stuff (dates, common errors, …)
gem 'rails-i18n'

# Other dependencies
gem 'geocoder', '~> 1.2.2'

# Nicer drop down boxes in the admin area
gem 'chosen-rails', '~> 1.1.0'

# Meetup API
gem 'ruby_meetup2', '~> 0.5.0'
# RSS parsing
gem 'feedjira', '~> 1.3.0'

# Bug Monitoring
gem 'bugsnag', '~> 3.0.0'

group :development do
  group :darwin do
    gem 'rb-fsevent', '~> 0.9.4'
    gem 'growl', '~> 1.0.3'
  end

  gem 'better_errors', '~> 1.1.0'
  gem 'binding_of_caller', '~> 0.7.1'

  # Faster test execution
  gem 'spring', '~> 1.1.3'
  gem 'spring-commands-rspec', '~> 1.0.2'

  # Guard
  gem 'guard', '~> 2.6.1'
  gem 'guard-rspec', '~> 4.2.10'
  gem 'guard-pow', '~> 2.0.0'
  gem 'guard-bundler', '~> 2.0.0'

  # Silence asset pipeline and make log usable again
  gem 'quiet_assets', '~> 1.0.3'


end

group :test, :development do
  gem 'database_cleaner', '1.3.0'
  gem 'rspec-rails',  '~> 3.4.2'
  gem 'factory_girl_rails', '~> 4.2'
  gem 'faker', '~> 1.4.1'
  gem 'codeclimate-test-reporter', '~> 0.4.8', require: nil
  gem 'brakeman', '~> 2.6.1'
  gem 'vcr', '~> 2.9.2'
  gem 'pry-rails'
  # Find and manage translation differences
  gem 'i18n-tasks', '~> 0.7.10'
  gem 'equivalent-xml', '~> 0.6.0'
end

group :test do
  gem 'webmock', '~> 1.17.3'
end

gem 'recaptcha', '0.3.6'
gem 'lograge', '~> 0.3.0'
