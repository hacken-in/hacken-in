# coding: utf-8
source 'https://rubygems.org'
ruby '2.4.3'

gem 'rails', '~> 4.2.10'

# Rack HTTP Server
gem 'puma', '~> 3.11.2'

# Databases
gem 'pg', '~> 0.21.0'

# Tags
gem 'acts-as-taggable-on', '~> 5.0.0'

# Assets
gem 'sass-rails', '~> 4.0.3'
gem 'coffee-script', '~> 2.2.0'
gem 'leaflet-rails', '~> 0.7.3'
gem 'uglifier', '~> 2.5.1'
gem 'jquery-rails', '~> 3.1.1'
gem 'foundation-rails', '5.4.5.0'
gem 'font-awesome-rails', '~> 4.1.0.0'
gem 'momentjs-rails', '~> 2.4.0'

# Haml Templating Language
gem 'haml', '~> 5.0.4'

# Markdown + Emojis
gem 'redcarpet', '~> 3.4.0'
gem 'md_emoji', '~> 1.0.2'

# Admin
gem 'activeadmin', '~> 1.0.0.pre2'
gem 'chosen-rails', '~> 1.1.0'

# Date Handling
gem 'ice_cube', '~> 0.11.1'
gem 'icalendar', '~> 1.5.2'

# Recurring Tasks
gem 'whenever', '~> 0.10.0'

# Authentication and Authorization
gem 'devise', '~> 4.4.1'
gem 'devise-i18n', '~> 1.5.0'
gem 'cancancan', '~> 2.1.3'
gem 'omniauth', '~> 1.8.1'
gem 'omniauth-github', '~> 1.3.0'
gem 'omniauth-twitter', '~> 1.4.0'

# Picture Upload
gem 'carrierwave', '~> 1.2.2'
gem 'mini_magick', '~> 4.8.0'

# Form Handling
gem 'simple_form', '~> 3.5.0'

# JavaScript runtime
gem 'execjs', '~> 2.2.1'
gem 'therubyracer', '~> 0.12.0'

# User Picture using Gravatar
gem 'gravatar_image_tag', '~> 1.2.0'

# For the auto follow script
gem 'twitter', '~> 6.2.0'

# Include some generic language stuff (dates, common errors, …)
gem 'rails-i18n'

# Geocode addresses
gem 'geocoder', '~> 1.4.5'

# Meetup API
gem 'ruby_meetup2', '~> 0.6.0'

# RSS parsing
gem 'feedjira', '~> 2.1.3'

# Bug Monitoring
gem 'bugsnag', '~> 6.6.3'

# Captchas
gem 'recaptcha', '4.6.3'

group :development do
  gem 'better_errors', '~> 2.4.0'
  gem 'binding_of_caller', '~> 0.8.0'

  # Silence asset pipeline and make log usable again
  gem 'quiet_assets', '~> 1.0.3'
end

group :test, :development do
  gem 'database_cleaner', '1.6.2'
  gem 'rspec-rails',  '~> 3.7.2'
  gem 'factory_girl_rails', '~> 4.2'
  gem 'faker', '~> 1.8.7'
  gem 'codeclimate-test-reporter', '~> 1.0.8'
  gem 'vcr', '~> 4.0.0'
  gem 'pry-rails'
  # Find and manage translation differences
  gem 'i18n-tasks', '~> 0.9.20'
  gem 'equivalent-xml', '~> 0.6.0'
end

group :test do
  gem 'webmock', '~> 3.3.0'
end
