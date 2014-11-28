module Framework
  module Extensions
    module ActiveRecord
      module BaseExtension
        extend ActiveSupport::Concern

        module ClassMethods

          # @override
          def inherited(child_class)
            super

            unless child_class == ::ActiveRecord::SchemaMigration
              if (chunks = child_class.name.split('::')).many?
                child_class.store_full_sti_class = false
                child_class.use_database(chunks.first.downcase)
              end
            end
          end

          # Makes your model use different databases
          # @param [String, Symbol] db_name
          # @param [String] env
          def use_database(db_name, env = nil)
            env ||= Framework.app.env
            env = env.to_s
            db_name = db_name.to_s

            self.abstract_class = Framework.env != 'test'
            self.table_name = self.name.split('::').last.tableize if self.superclass == ::ActiveRecord::Base
            establish_connection(Framework.app.database_config[db_name][env])
          end
        end
      end
    end
  end
end
ActiveRecord::Base.send :include, Framework::Extensions::ActiveRecord::BaseExtension
