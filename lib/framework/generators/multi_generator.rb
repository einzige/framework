require 'framework/generators/migration_generator'

module Framework
  class MultiGenerator < Thor::Group
    argument :target_type
    argument :target_name

    def self.source_root
      File.dirname(__FILE__)
    end

    def generate
      case target_type
      when 'migration'
        Framework::MigrationGenerator.new(db_name: (ENV['DB_NAME'] || 'default'), migration_name: target_name).generate
      else
        raise "Don't know how to build task 'generate #{target_type}'"
      end
    end
  end
end

