require 'json'

module Framework
  class DbListener
    attr_reader :db_name, :channel

    def initialize(channel: 'framework_notifications', db_name: 'default')
      @channel = channel.freeze
      @db_name = db_name.freeze
    end

    def listen
      connection = Framework.app.db_connection(db_name)
      connection.execute "LISTEN #{channel}"

      loop do
        connection.raw_connection.wait_for_notify do |event, pid, data|
          yield data.nil? ? data : JSON.parse(data)
        end
      end
    ensure
      connection.execute "UNLISTEN #{channel}"
    end
  end
end
