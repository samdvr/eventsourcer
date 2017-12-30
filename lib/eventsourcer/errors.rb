module Eventsourcer
  module Errors
    class Base < StandardError
    end

    class BrokerNotConfiguredError < Base
    end

    class BrokerNotFound < Base
    end
  end
end