source 'http://rubygems.org'

gem 'rails', '3.1.1'
gem 'rake', '~> 0.9'

# Databases
gem 'sqlite3'
gem 'mysql2'
gem 'memcache-client'

# Tags
gem 'acts-as-taggable-on', '~>2.1.0'

# Asset template engines
gem 'sass-rails', "~> 3.1.0"
gem 'coffee-script'
gem 'uglifier'
gem 'haml'
gem 'redcarpet', '~> 2.0.0b'

# Monitoring
gem 'newrelic_rpm', '~>3.1.1'

# Date Handling
gem 'ice_cube', "~> 0.6.12"
gem 'ri_cal', "~> 0.8.8"

# Other dependencies
gem 'jquery-rails'
gem 'devise', "~> 1.3"
gem 'cancan'
gem 'gabba'
gem 'formtastic', '~> 1.2.4'
gem 'geocoder', '~> 1.0'

# Javascript runtime
gem 'execjs'
gem 'therubyracer'

gem 'rdiscount' # for yard formatting

# Clipboard-Button on iCal Page
gem 'zero-clipboard-rails'
# User Picture using gravatar
gem 'gravatar_image_tag'
# Truncate HTML on SingelEvent Pages
gem 'html_truncator'

# facebook style tooltip jQuery plugin
gem 'tipsy-rails', :git => "git://github.com/nragaz/tipsy-rails.git"

group :development do
  # Deployment
  gem 'vlad', :require => false
  gem 'vlad-git', :require => false
  group :darwin do
    gem 'rb-fsevent'
    gem 'growl'
  end

  # guard
  gem 'guard'
  gem 'guard-test', "~> 0.4.0"
  gem 'guard-livereload'
  gem 'guard-pow'
  gem 'guard-bundler'
  gem 'guard-yard'
  gem 'guard-spork'
end

group :test do
  # Pretty printed test output
  # gem 'turn', :require => false
  gem 'factory_girl_rails', "~> 1.1.beta1"
  gem 'spork-testunit'
end
