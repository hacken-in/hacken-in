source 'http://rubygems.org'

gem 'rails', '~> 3.2.11'
gem 'rake', '~> 0.9'

# Databases
gem 'sqlite3', '~> 1.3.5', group: :test
gem 'mysql2', '~> 0.3.11'

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
gem 'acts-as-taggable-on', '~> 2.3.1'

# Asset template engines
gem 'sass-rails', '~> 3.2.3'
gem 'coffee-script', '~> 2.2.0'
# TODO: Investigate if we can take version instead of Repo
gem 'leaflet-rails', github: 'axyjo/leaflet-rails'
gem 'uglifier', '~> 1.2.0'
gem 'haml', '~> 3.1.4'
gem 'jquery-rails', '~> 2.0.0'
gem 'md_emoji', '~> 1.0.0'
gem 'redcarpet', '~> 2.1.0'
gem 'pjax_rails', '~> 0.3.3'

# Admin
# TODO: Investigate if we can take version instead of Repo
gem 'activeadmin', git: 'https://github.com/gregbell/active_admin.git'
# TODO: Investigate if this is used in the Admin area
gem 'ckeditor_rails', '~> 3.6.4.1', require: 'ckeditor-rails'

# Monitoring
gem 'newrelic_rpm', '~> 3.4.0'

# Date Handling
gem 'ice_cube', '~> 0.8.0'
gem 'ri_cal', '~> 0.8.8'

# Authentication
gem 'devise', '~> 2.1.1'

# Authorization
gem 'cancan', '~> 1.6.7'

# Omniauth
gem 'omniauth', '~> 1.1.1'
gem 'omniauth-google-oauth2', '~> 0.1.13'
gem 'omniauth-github', '~> 1.0.3'
gem 'omniauth-twitter', '~> 0.0.13'
gem 'omniauth-facebook', '~> 1.4.1'
gem 'omniauth-linkedin', '~> 0.0.8'

# Picture Upload
gem 'carrierwave', '~> 0.6.2'
gem 'mini_magick', '~> 3.4'

# MP3 Player
gem 'mediaelement_rails', '~> 0.4.0'

# Form Handling
# TODO: Throw away formtastic when we do not use it in the frontend anymore
# (if we only use it in the admin area, the dependency is handled by AA)
gem 'formtastic', '~> 2.2.0'
gem 'simple_form', '~> 2.0.4'

# JavaScript runtime
# TODO: Please investigate why both are here
gem 'execjs', '~> 1.4.0'
gem 'therubyracer', '~> 0.10.1'

# Clipboard-Button on iCal Page
gem 'zero-clipboard-rails', '~> 1.0.1'
# User Picture using Gravatar
gem 'gravatar_image_tag', '~> 1.1.0'
# Truncate HTML on SingleEvent Pages
# TODO: Where exactly? I only see Active Support truncate usage
gem 'html_truncator', '~> 0.3.0'

# Frontend
gem 'bootstrap-sass-rails', '~> 2.1.1.0'
gem 'smurfville', '~> 0.0.6'

# Pagination
gem 'bootstrap-kaminari-views', '~> 0.0.2'

# Facebook style tooltip jQuery plugin
gem 'tipsy-rails', '~> 1.0.2'

# Sample Data
# TODO: Investigate if this belongs to the development group
gem 'faker', '1.0.1'

# Other dependencies
gem 'gabba', '~> 0.3.0'
# Attention: If you want to change to 1.1.3, you need to adjust our Code
# (Geocoder, Y U NO Semantic Versioning?)
gem 'geocoder', '= 1.1.2'
gem 'simple-navigation', '~> 3.9.0'

# Date parsing in Javascript
gem 'momentjs-rails', '~> 1.7.0'

group :development do
  # Deployment
  gem 'capistrano', '~> 2.13.0'

  group :darwin do
    gem 'rb-fsevent', '~> 0.9.0pre4'
    gem 'growl', '~> 1.0.3'
  end

  # Guard
  gem 'guard', '~> 1.3.0'
  gem 'guard-test', '~> 0.5.0'
  gem 'guard-pow', '~> 1.0.0'
  gem 'guard-bundler', '~> 1.0.0'
end

group :test do
  gem 'factory_girl_rails', '~> 3.5', require: false
  gem 'spork-testunit', '~> 0.0.7'
  gem 'mocha', '~> 0.12.0', require: false
end
