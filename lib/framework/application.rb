require 'framework/root'
require 'framework/config'
require 'action_dispatch/middleware/reloader'
require 'action_dispatch/middleware/callbacks'

module Framework
  class Application
    CONFIG_PATH = "config/application.yml"

    attr_reader :env
    attr_accessor :logger
    attr_reader :root
    delegate :hint, :note, :whisper, :disappointment, to: :logger

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
      note "Establishing database connection"
      establish_database_connection
      require_dependencies 'config/initializers'
      load_application_files
      note "Application has been initialized"
      self
    end

    def reload!
      @config = nil
      disappointment "Reloading #{env}"
      load_application_config
      load_application_files
      self
    end

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

    # Autoloads all app-specific files
    def load_application_files
      if %w(development test).include?(env.to_s)
        config['autoload_paths'].each(&method(:autoreload_constants))
        autoreload_yml
      end
      config['autoload_paths'].each(&method(:require_dependencies))
    end

    def autoreload_yml(path=root)
      autoreload(path, 'yml') { @yml_reloaded = true } unless @yml_reloaded
    end

    def autoreload(path=root, ext, &block)
      files = Dir[root.join(path, "/**/*.#{ext}")]

      reloader = ActiveSupport::FileUpdateChecker.new(files) do
        whisper "Reloading .#{ext} files"
        block.try(:call, files)
        Framework.app.reload!
      end

      ActionDispatch::Callbacks.to_prepare do
        reloader.execute_if_updated
      end
    end

    def autoreload_constants(path)
      return if reloadable_paths.include?(path)

      ActiveSupport::Dependencies.autoload_paths += [root.join(path)]
      absolute_path = Pathname.new(root.join(path))

      autoreload(path, 'rb') do |files|
        files.each do |file_path|
          pathname = Pathname.new(file_path)

          # Get Const Name
          const_name = pathname.basename.to_s.sub('.rb', '').camelize.to_sym
          full_name = pathname.relative_path_from(absolute_path).sub('.rb', '').to_s.camelize

          # Get Module Name
          relative_file_path = Pathname.new(pathname.dirname).relative_path_from(absolute_path).to_s

          if Object.const_defined?(full_name)
            if relative_file_path == '.'
              Object.send :remove_const, const_name
            else
              module_name = relative_file_path.camelize
              module_name.constantize.send(:remove_const, const_name)
            end
          end
        end
      end

      reloadable_paths << path
    end

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

    # @return [Hash]
    def load_application_config
      @config = Framework::Config.new(YAML.load(erb(CONFIG_PATH).result)[env])
    end

    # @return [Hash]
    def load_database_config
      @database_config = YAML.load(erb('config/databases.yml').result)
    end

    # @param [String] path
    def erb(path)
      ERB.new(File.read(root.join(path)))
    end

    # @param [String] path
    def load_path(path)
      Dir["#{path}/**/*.rb"].each(&method(:require_dependency))
    end

    # @return [IO, nil]
    def log_level
      config['enable_logging'] ? STDOUT : nil
    end

    # @return [Framework::Logger]
    def logger
      @logger ||= Framework::Logger.new(log_level)
    end

    def reloadable_paths
      @reloadable_paths ||= []
    end

    def require_dependencies(autoload_path)
      path = root.join(autoload_path)

      if path.end_with?('.rb')
        require_dependency(path)
      else
        load_path(File.join(path, 'concerns'))

        Dir["#{path}/**/*.rb"].each do |path_to_load|
          require_dependency(path_to_load) unless path_to_load.include?('concerns/')
        end
      end
    end
  end
end
