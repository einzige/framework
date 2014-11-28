module Framework
  class Migration < ActiveRecord::Migration

    def self.use_database(db_name)
      define_method :connection do
        @connection ||= begin
          Framework::Logger.whishper "Using database: #{db_name}"
          Framework.app.db_connection(db_name)
        end
      end
    end
  end
end
