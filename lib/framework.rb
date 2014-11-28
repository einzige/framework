require 'active_record'
require 'bundler'

require 'framework/version'
require 'framework/extensions/active_record/base_extension'
require 'framework/logger'
require 'framework/application'
require 'framework/db_listener'

module Framework
  DEFAULT_ENV = 'development'.freeze

  # @return [Framework::Application]
  def self.app
    @app
  end

  # @param [Framework::Application] app
  def self.app=(app)
    @app = app
  end

  def self.env
    @app ? @app.env : (ENV['FRAMEWORK_ENV'] || DEFAULT_ENV)
  end
end

begin
  Bundler.require(:default, Framework.env)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
