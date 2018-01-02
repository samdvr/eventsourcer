module Eventsourcer
  class BrokerFactory
    def self.build
      raise Eventsourcer::Errors::BrokerNotConfiguredError unless Eventsourcer.configuration
      return fetch_broker_klass(Eventsourcer.configuration.broker)
    end

    private

    def self.fetch_broker_klass(configured_broker)
      if configured_broker == :kafka
        return Eventsourcer::Brokers::KafkaBroker
      else
        raise Eventsourcer::Errors::BrokerNotFound
      end
    end
  end

end
