module Eventsourcer
  class BrokerFactory
    def self.build
      raise Eventsourcer::Errors::BrokerNotConfiguredError unless Eventsourcer.configuration
      configured_broker = Eventsourcer.configuration.broker
      if configured_broker == :kafka
        return Eventsourcer::Brokers::KafkaBroker
      else
        raise Eventsourcer::Errors::BrokerNotFound
      end
    end
  end
end
