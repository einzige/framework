require 'erb'

module Framework
  class MigrationGenerator

    def initialize(db_name: db_name, migration_name: name)
      @db_name = db_name.underscore
      @migration_name = migration_name.underscore
      @timestamp = Time.now.utc.strftime("%Y%m%d%H%M%S")
      @path = "db/migrations/#{@timestamp}_#@migration_name.rb"
    end

    def generate
      context = Context.new(@db_name, @migration_name).template_binding
      migration_file = File.open(@path, "w+")
      migration_file << ERB.new(template).result(context)
      migration_file.close

      Framework.app.hint "Generated migration: #@path"
    end

    def templates_path
      File.expand_path(File.join(File.dirname(__FILE__), '../templates'))
    end

    def template
      @template ||= File.read(File.join(templates_path, "migration.rb.erb"))
    end

    class Context
      attr_accessor :migration_name, :db_name

      def initialize(db_name, migration_name)
        @migration_name = migration_name.camelize
        @db_name = db_name.underscore
        validate!
      end

      def template_binding
        binding
      end

      def load_migrations
        Dir["./db/migrations/**/*.rb"].each(&method(:load))
      rescue
        raise "An error was occurred"
      end

      def validate!
        load_migrations
        Module.const_get(@migration_name)
        raise "Migration with the same name already exists"
      rescue NameError
        true
      end
    end
  end
end
