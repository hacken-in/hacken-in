source 'http://rubygems.org'

gem 'rails', '~> 3.2.0.rc2'
gem 'rake', '~> 0.9'

# Databases
gem 'sqlite3', '~> 1.3.5'
gem 'mysql2', '~> 0.3.11'
gem 'memcache-client', '~> 1.8.5'

# Tags
gem 'acts-as-taggable-on', '~> 2.2.0'

# Asset template engines
gem 'sass-rails', '~> 3.2.3'
gem 'coffee-script', '~> 2.2.0'
gem 'uglifier', '~> 1.2.0'
gem 'haml', '~> 3.2.0.alpha.8'
gem 'redcarpet', '~> 2.0.0b'

# Monitoring
gem 'newrelic_rpm', '~> 3.3.1'

# Date Handling
gem 'ice_cube', '~> 0.7'
gem 'ri_cal', '~> 0.8.8'

# Authentication
gem 'devise', '~> 1.3'
# Authorisation
gem 'cancan', '~> 1.6.7'

# Other dependencies
gem 'jquery-rails', '~> 2.0.0'
gem 'gabba', '~> 0.1.1'
gem 'formtastic', '~> 2.0.2'
gem 'geocoder', '~> 1.0'

# Javascript runtime
gem 'execjs', '~> 1.2.12'
gem 'therubyracer', '~> 0.10.0beta1'

gem 'rdiscount', '~> 1.6.8' # for yard formatting

# Clipboard-Button on iCal Page
gem 'zero-clipboard-rails', '~> 1.0.1'
# User Picture using gravatar
gem 'gravatar_image_tag', '~> 1.0.0'
# Truncate HTML on SingelEvent Pages
gem 'html_truncator', '~> 0.3.0'

# facebook style tooltip jQuery plugin
gem 'tipsy-rails', '~> 1.0.2'

group :development do
  # Deployment
  gem 'vlad', '~> 2.2.3', :require => false
  gem 'vlad-git', '~> 2.2.0', :require => false
  group :darwin do
    gem 'rb-fsevent', '~> 0.9.0pre4'
    gem 'growl', '~> 1.0.3'
  end

  # guard
  gem 'guard', '~> 0.10.0'
  gem 'guard-test', '~> 0.4.0'
  gem 'guard-livereload', '~> 0.4.0'
  gem 'guard-pow', '~> 0.2.1'
  gem 'guard-bundler', '~> 0.1.3'
  gem 'guard-yard', '~> 1.0.2'
  gem 'guard-spork', '~> 0.5.1'
end

group :test do
  # Pretty printed test output
  # gem 'turn', :require => false
  gem 'factory_girl_rails', '~> 1.1.beta1', :require => false
  gem 'spork-testunit', '~> 0.0.7'
end
