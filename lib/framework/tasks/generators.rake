require 'framework/generators/migration_generator'

namespace :g do
  desc "Generates migration"
  task :migration, [:db_name, :migration_name] => :environment do |_, args|
    Framework::MigrationGenerator.new(db_name: args[:db_name], migration_name: args[:migration_name]).generate
  end
end
