source 'http://rubygems.org'

gem 'rails', '3.1.0.rc4'
gem 'rake', '~> 0.9'

# Databases
gem 'sqlite3'
gem 'mysql2'

# Asset template engines
gem 'sass-rails', "~> 3.1.0.rc"
gem 'coffee-script'
gem 'uglifier'

# Monitoring
# gem 'newrelic_rpm'

# Date Handling
gem 'ice_cube', "~> 0.6.7"
gem 'ri_cal', "~> 0.8.8"

# Other dependencies
gem 'jquery-rails'
gem 'devise', "~> 1.3"

# Javascript runtime
gem 'execjs'
gem 'therubyracer'

group :development do
  # Deployment
  gem 'vlad', :require => false
  gem 'vlad-git', :require => false
end

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
  gem 'guard'
  gem 'guard-test'
  gem 'guard-livereload'
  if RUBY_PLATFORM.downcase.include?("darwin") 
    gem 'rb-fsevent'
    gem 'growl'
  end

end
