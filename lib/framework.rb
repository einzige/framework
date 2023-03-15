require 'active_record'
require 'bundler'

require 'framework/version'
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
    @app ? @app.env : (ENV['FRAMEWORK_ENV'] || ENV['RAILS_ENV'] || DEFAULT_ENV)
  end

  # Returns current work dir String
  # @return [Framework::Root]
  def self.root
    @app.try(:root)
  end
end
