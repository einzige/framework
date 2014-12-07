require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/string/strip'

module Framework
  class ApplicationGenerator < Thor::Group
    include Thor::Actions

    argument :name

    def self.source_root
      File.dirname(__FILE__)
    end

    def create_base_directories
      empty_directory 'app/models'
      empty_directory 'app/models/concerns'
      create_file 'app/models/concerns/.keep'

      empty_directory 'lib'
      create_file 'lib/.keep'

      empty_directory 'db'
      empty_directory 'db/migrate'
      create_file 'db/migrate/.keep'
    end

    def create_application_config
      create_file 'config/application.yml' do
        <<-CONFIG.strip_heredoc
        development: &common
          enable_logging: yes
          autoload_paths:
            - app/models
          default_timezone: 'Pacific Time (US & Canada)'

        test:
          <<: *common
          enable_logging: no

        staging:
          <<: *common

        production:
          <<: *common
          enable_logging: no
        CONFIG
      end
    end

    def create_database_config
      db_name = name.underscore

      create_file 'config/databases.yml' do
        <<-CONFIG.strip_heredoc
        # Defult database is used by default.
        # Any models locating at app/models root directory will point to this database by default.
        default:
          development: &common
            adapter: postgresql
            username:
            password:
            database: #{db_name}_development
            min_messages: WARNING
            reconnect: true
            pool: 5
            encoding: unicode
            host: localhost

          test:
            <<: *common
            database: #{db_name}_test

          production:
            <<: *common
            database: #{db_name}_production

        # Custom one. Models located at app/models/second_one path will point to this database by default.
        second_one:
          development: &common
            adapter: postgresql
            username:
            password:
            database: second_sample_development
            min_messages: WARNING
            reconnect: true
            pool: 5
            encoding: unicode
            host: localhost

          test:
            <<: *common
            database: second_sample_test

          production:
            <<: *common
            database: second_sample_production
        CONFIG
      end
    end

    def create_environment
      create_file 'config/environment.rb' do
        <<-CONFIG.strip_heredoc
        # Set up gems listed in the Gemfile.
        ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)
        require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

        require 'framework'

        Bundler.require(:default, Framework.env)

        Framework::Application.new do |app|
          app.init!
        end
        CONFIG
      end
    end

    def create_gemfile
      create_file 'Gemfile' do
        <<-CONFIG.strip_heredoc
          source 'https://rubygems.org'

          gem 'framework', '#{Framework::VERSION}'
          gem 'pg'
        CONFIG
      end
    end

    def create_rakefile
      create_file 'Rakefile' do
        <<-CONFIG.strip_heredoc
        # Add your own tasks in files placed in lib/tasks ending in .rake,
        # for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

        require 'framework'
        require 'framework/rake'

        Dir["\#{Dir.pwd}/app/tasks/**/*.rake"].each(&method(:load))
        CONFIG
      end
    end

    def create_sample_tasks
      empty_directory 'app/tasks'
      create_file 'app/tasks/hello.rake' do
        <<-RAKE.strip_heredoc
        task hello: :environment do
          Framework::Logger.disappointment("Hello from: Framework v#{Framework::VERSION}")
        end
        RAKE
      end
    end

    def create_sample_initializers
      empty_directory 'config/initializers'
      create_file 'config/initializers/time_zone.rb' do
        <<-CONFIG.strip_heredoc
          # Sample usage of application config
          Time.zone = Framework.app.config['default_timezone']
        CONFIG
      end
    end

    def create_readme
      create_file 'README.md', "This app utilizes Framework v#{Framework::VERSION} and rocks MIT license."
    end
  end
end
