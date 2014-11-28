# This file is copied to spec/ when you run 'rails generate rspec:install'
env = ENV["FRAMEWORK_ENV"] ||= 'test'
require 'framework'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec'
require 'database_cleaner'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.expand_path("../../spec/support/**/*.rb", __FILE__)].each(&method(:load))

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  config.raise_errors_for_deprecations!
  config.order = "random"
  config.color = true
  config.formatter = :documentation
end
