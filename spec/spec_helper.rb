# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'

require 'simplecov'
require 'coveralls'
require 'vcr'
require 'webmock/rspec'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
end

require File.expand_path("../../config/environment", __FILE__)
require 'database_cleaner'
require 'rspec/rails'
require 'rspec/autorun'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

# Database Cleaner
DatabaseCleaner[:active_record, { connection: :test }]

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.fixture_path = "#{::Rails.root}/spec/support/fixtures"
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"

  config.before(:suite) { DatabaseCleaner.strategy = :truncation }
  config.before(:each)  { DatabaseCleaner.start }
  config.after(:each)   { DatabaseCleaner.clean }
end

# Mock GeoCoder
# inspired by https://github.com/alexreisner/geocoder/blob/5d769cb343bc7559320649f4c329b11270990754/test/test_helper.rb#L45

require "geocoder"
require "geocoder/lookups/google"

module Geocoder
  module Lookup
    class Google < Base
      private
      def fetch_raw_data(query, reverse = false)
        file = File.join("spec", "support", "fixtures", "#{self.class.name.parameterize}_#{query.to_s.parameterize}.json")
        unless File.exists? file
          result = super rescue "FAIL"
          File.new(file, "w+").puts result.force_encoding("utf-8")
          result
        else
          File.read(file).strip.gsub(/\n\s*/, "")
        end
      end
    end
  end
end

