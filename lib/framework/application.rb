require 'framework/root'

module Framework
  class Application
    CONFIG_PATH = "config/application.yml"

    attr_reader :env
    attr_accessor :logger
    attr_reader :root
    delegate :hint, :note, to: :logger

    # @param [String] env Environment from configuration file
    def initialize(env: nil, root: nil)
      @env = env || Framework.env
      @root = Root.new(root || Dir.pwd)
      Framework.app = self
      yield self if block_given?
    end

    # Entry point for the app
    # @return [Application]
    def init!
      @logger = @config = @database_config = nil

      load_application_config
      load_database_config
      note "Loading #{env} environment (#{Framework::VERSION})"
      autoload
      note "Establishing database connection"
      establish_database_connection
      note "Application has been initialized"
      self
    end
    alias_method :reload!, :init!

    # @return [Hash<String>]
    def config
      @config || load_application_config
    end

    def create_database!(name = nil)
      name ||= 'default'
      cfg = database_config[name][env]

      case cfg['adapter']
      when 'postgresql'
        establish_postgres_connection(name)
        ActiveRecord::Base.connection.create_database(cfg['database'])
      when 'sqlite3'
        raise 'Database already exists' if File.exist?(cfg['database'])
        establish_database_connection
      else
        raise "Unknown adapter '#{cfg['adapter']}'"
      end

      puts "The database #{cfg['database']} has been successfully created"
    end

    def drop_database!(name = nil)
      name ||= 'default'
      cfg = database_config[name][env]

      case cfg['adapter']
      when 'postgresql'
        establish_postgres_connection(name)
        ActiveRecord::Base.connection.drop_database(cfg['database'])
      when 'sqlite3'
        require 'pathname'
        path = Pathname.new(cfg['database']).to_s
        FileUtils.rm(path) if File.exist?(path)
      else
        raise "Unknown adapter '#{cfg['adapter']}'"
      end

      puts "The database #{database_config[name][env]['database']} has been successfully dropped"
    end

    def migrate_database(version = nil)
      ActiveRecord::Migrator.migrate root.join("db/migrate"), version.try(:to_i)
    end

    def rollback_database(steps = 1)
      ActiveRecord::Migrator.rollback root.join("db/migrate"), steps
    end

    # @return [Hash<String>]
    def database_config
      @database_config || load_database_config
    end

    # @return [String] Database name
    def database
      adapter  = database_config['default'][env]['adapter']
      database = database_config['default'][env]['database']
      adapter == 'sqlite3' ? root.join("db/sqlite/#{env}/#{database}.db") : database
    end

    def self.init!
      yield Framework::Application.new.init!
    end

    def db_connection(db_name = 'default')
      ActiveRecord::Base.establish_connection(database_config[db_name][env])
      ActiveRecord::Base.connection
    end

    private

    def establish_database_connection
      if database_config
        database_config.each do |_, db_config|
          ActiveRecord::Base.establish_connection(db_config[env])

          if db_config[env]['enable_logging']
            ActiveRecord::Base.logger = Logger.new(STDOUT)
          end
        end
      end
    end

    # Used to create/drop db
    def establish_postgres_connection(name = 'default')
      if database_config[name]
        ActiveRecord::Base.establish_connection(database_config[name][env].merge('database' => 'postgres',
                                                                                 'schema_search_path' => 'public'))
      end
    end

    # Autoloads all app-specific files
    def autoload
      config['autoload_paths'].each do |autoload_path|
        path = root.join(autoload_path)

        if path.end_with?('.rb')
          load(path)
        else
          load_path(File.join(path, 'concerns'))

          Dir["#{path}/**/*.rb"].each do |path_to_load|
            load(path_to_load) unless path_to_load.include?('concerns/')
          end
        end
      end
    end

    # @return [Hash]
    def load_application_config
      @config = YAML.load_file(root.join(CONFIG_PATH))[env]
    end

    # @return [Hash]
    def load_database_config
      @database_config = YAML.load_file(root.join('config/databases.yml'))
    end

    # @param [String] path
    def load_path(path)
      Dir["#{path}/**/*.rb"].each(&method(:load))
    end

    # @return [IO, nil]
    def log_level
      config['enable_logging'] ? STDOUT : nil
    end

    # @return [Framework::Logger]
    def logger
      @logger ||= Framework::Logger.new(log_level)
    end
  end
end
