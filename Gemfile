source 'http://rubygems.org'

gem 'rails', '3.1.0'
gem 'rake', '~> 0.9'

# Databases
gem 'sqlite3'
gem 'mysql2'
gem 'memcache-client'

# Asset template engines
gem 'sass-rails', "~> 3.1.0"
gem 'coffee-script'
gem 'uglifier'
gem 'haml'

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
  gem 'guard-test'
  gem 'guard-livereload'
  gem 'guard-pow'
  gem 'guard-bundler'
  gem 'guard-yard'

  gem 'rdiscount' # for yard formatting
end

group :test do
  # Pretty printed test output
  # gem 'turn', :require => false
  gem 'factory_girl_rails', "~> 1.1.beta1"
end
