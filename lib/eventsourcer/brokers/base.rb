module Eventsourcer
  module Brokers
    class Base
      def self.publish(table_name:, previous_changes:)
        raise NotImplementedError
      end
    end
  end
end
