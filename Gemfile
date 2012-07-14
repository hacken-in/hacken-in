source 'http://rubygems.org'

gem 'rails', '~> 3.2.6'
gem 'rake', '~> 0.9'

# Databases
gem 'sqlite3', '~> 1.3.5'
gem 'mysql2', '~> 0.3.11'

# Memcache Store
# DO NOT UPGRADE THIS
# We need exactly this version, because
# never versions cant' connect to unix
# sockets. See here:
#
#  https://github.com/mperham/dalli/issues/229
#
gem 'dalli', '~> 1.1.5'

# Tags
gem 'acts-as-taggable-on', '~> 2.3.1'

# Asset template engines
gem 'sass-rails', '~> 3.2.3'
gem 'coffee-script', '~> 2.2.0'
gem 'uglifier', '~> 1.2.0'
gem 'haml', '~> 3.1.4'
gem 'redcarpet', '~> 2.1.0'


# Monitoring
gem 'newrelic_rpm', '~> 3.4.0'

# Date Handling
gem 'ice_cube', "~> 0.8.0"
gem 'ri_cal', "~> 0.8.8"

# Authentication
gem 'devise', '~> 2.1.1'
# Authorisation
gem 'cancan', '~> 1.6.7'

#Omniauth 
gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'omniauth-github'
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'omniauth-linkedin'

# Other dependencies
gem 'jquery-rails', '~> 2.0.0'
gem 'gabba', '~> 0.3.0'
gem 'formtastic', '~> 2.2.0'
gem 'geocoder', '~> 1.0'

# Javascript runtime
gem 'execjs', '~> 1.4.0'
gem 'therubyracer', '~> 0.10.1'

# Clipboard-Button on iCal Page
gem 'zero-clipboard-rails', '~> 1.0.1'
# User Picture using gravatar
gem 'gravatar_image_tag', '~> 1.1.0'
# Truncate HTML on SingleEvent Pages
gem 'html_truncator', '~> 0.3.0'

# facebook style tooltip jQuery plugin
gem 'tipsy-rails', '~> 1.0.2'

group :development do
  # Deployment
  gem 'vlad', '~> 2.2.3', require: false
  gem 'vlad-git', '~> 2.2.0', require: false

  group :darwin do
    gem 'rb-fsevent', '~> 0.9.0pre4'
    gem 'growl', '~> 1.0.3'
  end

  # YARD:
  gem 'yard', '~> 0.8.2.1'
  gem 'rdiscount', '~> 1.6.8'

  # guard
  gem 'guard', '~> 1.2.3'
  gem 'guard-test', '~> 0.5.0'
  gem 'guard-livereload', '~> 1.0.0'
  gem 'guard-pow', '~> 1.0.0'
  gem 'guard-bundler', '~> 1.0.0'
  gem 'guard-yard', '~> 2.0.0'
end

group :test do
  # Pretty printed test output
  # gem 'turn', require: false
  gem 'factory_girl_rails', '~> 3.5', require: false
  gem 'spork-testunit', '~> 0.0.7'
  gem 'mocha', '~> 0.12.0', require: false
end
