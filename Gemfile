source 'https://rubygems.org'

gem 'rails', '~> 3.2.13'
gem 'rake', '~> 10.0.3'

# Databases
gem 'sqlite3', '~> 1.3.7', group: :test
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
gem 'acts-as-taggable-on', '~> 2.3.3'

# Asset template engines
gem 'sass-rails', '~> 3.2.6'
gem 'coffee-script', '~> 2.2.0'
gem 'leaflet-rails', '~> 0.5.0'
gem 'uglifier', '~> 1.3.0'
gem 'haml', '~> 3.1.8'
# TODO: gem 'haml', '~> 4.0.0'
gem 'jquery-rails', '~> 2.2.1'
gem 'md_emoji', '~> 1.0.0'
gem 'redcarpet', '~> 2.2.2'
gem 'pjax_rails', '~> 0.3.4'
gem 'compass-rails', '~> 1.0.3'

# Admin
gem 'coffee-script-source', '~> 1.4.0' # See https://github.com/gregbell/active_admin/issues/1773
gem 'activeadmin', '~> 0.5.1'
gem 'ckeditor_rails', '~> 3.6.4.1', require: 'ckeditor-rails'

# Monitoring
gem 'newrelic_rpm', '~> 3.5.8.70'

# Date Handling
gem 'ice_cube', '~> 0.8.0'
# TODO: gem 'ice_cube', '~> 0.10.0'
gem 'ri_cal', '~> 0.8.8'

# Authentication and Authorization
gem 'devise', '~> 2.2.3'
gem 'cancan', '~> 1.6.7'
gem 'omniauth', '~> 1.1.3'
gem 'omniauth-google-oauth2', '~> 0.1.13'
gem 'omniauth-github', '~> 1.1.0'
gem 'omniauth-twitter', '~> 0.0.14'
gem 'omniauth-facebook', '~> 1.4.1'
gem 'omniauth-linkedin', '~> 0.1.0'

# Picture Upload
gem 'carrierwave', '~> 0.8.0'
gem 'mini_magick', '~> 3.5.0'

# MP3 Player
gem 'mediaelement_rails', '~> 0.5.0'

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
gem 'gravatar_image_tag', '~> 1.1.3'
# Truncate HTML on SingleEvent Pages
# TODO: Where exactly? I only see Active Support truncate usage
gem 'html_truncator', '~> 0.3.0'

# Frontend
gem 'bootstrap-sass-rails', '~> 2.3.0.0'
gem 'smurfville', github: 'railslove/smurfville', branch: 'nerdhub'

# Pagination
gem 'bootstrap-kaminari-views', '~> 0.0.2'

# Facebook style tooltip jQuery plugin
gem 'tipsy-rails', '~> 1.0.3'

# Other dependencies
gem 'gabba', '~> 0.3.0'
# TODO: gem 'gabba', '~> 1.0.1'

# TODO: Update geocoder
# *Attention:* If you want to change to 1.1.3, you need to adjust our Code
# (Geocoder, Y U NO Semantic Versioning?)
gem 'geocoder', '= 1.1.2'
gem 'simple-navigation', '~> 3.10.0'

# Date parsing in Javascript
gem 'momentjs-rails', '~> 1.7.2'

group :development do
  # Deployment
  gem 'capistrano', '~> 2.13.0'

  group :darwin do
    gem 'rb-fsevent', '~> 0.9.0pre4'
    gem 'growl', '~> 1.0.3'
  end

  gem 'better_errors', '~> 0.7.0'
  gem 'binding_of_caller', '~> 0.7.1'

  # Guard
  gem 'guard', '~> 1.6.2'
  gem 'guard-test', '~> 0.7.0'
  gem 'guard-pow', '~> 1.0.0'
  gem 'guard-bundler', '~> 1.0.0'
end

group :test do
  gem 'factory_girl_rails', '~> 3.5', require: false
  gem 'spork-testunit', '~> 0.0.7'
  gem 'faker', '~> 1.1.2'

  # Something is inherently wrong with mocha
  # I can smell it
  # Keep this versions locked unless you know what
  # you're doing
  gem 'test-unit', '2.5.3'
  gem 'mocha', '0.12.8'
end
