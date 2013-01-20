ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'spork'
Spork.prefork do
  ENV["RAILS_ENV"] = "test"
  require File.expand_path('../../config/environment', __FILE__)
  Spork.trap_method(Rails::Application::RoutesReloader, :reload!)
  require 'rails/test_help'
end


Spork.each_run do
  require 'factory_girl_rails'
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting

  # Add more helper methods to be used by all tests here...
end

#  mock geocoder inspired by https://github.com/alexreisner/geocoder/blob/5d769cb343bc7559320649f4c329b11270990754/test/test_helper.rb#L45
require "geocoder"
require "geocoder/lookups/google"

module Geocoder
  module Lookup
    class Google < Base
      private
      def fetch_raw_data(query, reverse = false)
        file = File.join("test", "fixtures", "#{self.class.name.parameterize}_#{query.parameterize}.json")
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

# Mocha muss als letztes geladen werden
require 'mocha/setup'
