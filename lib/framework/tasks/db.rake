require 'framework/migration'

namespace :db do
  desc "Creates database"
  task :create, :name do |_, args|
    puts "Loading #{Framework.env}"
    Framework::Application.new.create_database!(args[:name])
  end

  desc "Drops database"
  task :drop, :name do |_, args|
    puts "Loading #{Framework.env}"
    Framework::Application.new.drop_database!(args[:name])
  end

  desc "Runs migrations"
  task :migrate, [:version] => :environment do |_, args|
    Framework.app.migrate_database(args.version)
  end

  desc "Rolls back"
  task :rollback, [:num_steps] => :environment do |_, args|
    Framework.app.rollback_database((args.num_steps || 1).to_i)
  end

  namespace :test do
    desc "Creates test database"
    task :create, :name do |_, args|
      env = 'test'
      puts "Loading #{env.inspect}"
      Framework::Application.new(env).create_database!(args[:name])
    end

    desc "Drops test database"
    task :drop, :name do |_, args|
      env = 'test'
      puts "Loading #{env.inspect}"
      Framework::Application.new(env).drop_database!(args[:name])
    end

    desc "Runs test migrations"
    task :migrate do
      env = 'test'
      puts "Loading #{env.inspect}"
      Framework::Application.new(env).init!
      ActiveRecord::Migrator.migrate('db/migrations/')
    end
  end
end
