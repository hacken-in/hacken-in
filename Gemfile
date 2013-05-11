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
group :assets do
  gem 'sass-rails', '~> 3.2.6'
  gem 'coffee-script', '~> 2.2.0'
  gem 'leaflet-rails', '~> 0.5.0'
  gem 'uglifier', '~> 1.3.0'
  gem 'jquery-rails', '~> 2.2.1'
  gem 'pjax_rails', '~> 0.3.4'
  gem 'compass-rails', '~> 1.0.3'
  gem 'bootstrap-sass-rails', '~> 2.3.0.0'
  gem 'zero-clipboard-rails', '~> 1.0.1'                        # Clipboard-Button on iCal Page
  gem 'momentjs-rails', '~> 1.7.2'                              # Date parsing in Javascript
  gem 'tipsy-rails', '~> 1.0.3'                                 # Facebook style tooltip jQuery plugin
  gem "font-awesome-rails", '~> 3.0.2'
end

gem 'haml', '~> 3.1.8'
# TODO: gem 'haml', '~> 4.0.0'
gem 'md_emoji', '~> 1.0.0'
gem 'redcarpet', '~> 2.2.2'

# Admin
gem 'coffee-script-source', '~> 1.4.0' # See https://github.com/gregbell/active_admin/issues/1773
gem 'activeadmin', '~> 0.5.1'

# Date Handling
# TODO: gem 'ice_cube', '~> 0.10.0'
gem 'ice_cube', '~> 0.8.0'
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

# Form Handling
gem 'simple_form', '~> 2.0.4'

# JavaScript runtime
gem 'execjs', '~> 1.4.0'
gem 'therubyracer', '~> 0.11.4'

# User Picture using Gravatar
gem 'gravatar_image_tag', '~> 1.1.3'

# Pagination
gem 'bootstrap-kaminari-views', '~> 0.0.2'

# Other dependencies
gem 'gabba', '~> 1.0.1'
gem 'simple-navigation', '~> 3.10.0'
# TODO: Update geocoder
# *Attention:* If you want to change to 1.1.3, you need to adjust our Code
# (Geocoder, Y U NO Semantic Versioning?)
gem 'geocoder', '= 1.1.2'

gem 'nokogiri', '~> 1.5.9'

# Paginating - for search
gem 'will_paginate', '~> 3.0.4'
gem "will_paginate-bootstrap", "~> 0.2.2"

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
  gem 'guard-rspec'
  gem 'guard-pow', '~> 1.0.0'
  gem 'guard-bundler', '~> 1.0.0'
end

group :test, :development do
  gem 'rspec-rails',  '~> 2.0'
  gem 'factory_girl_rails', '~> 4.2'
  gem 'faker', '~> 1.1.2'
end
