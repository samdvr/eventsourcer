module Eventsourcer
  class BrokerFactory
    def self.build
      case broker
      when :kafka
        return Eventsourcer::Brokers::KafkaBroker
      end
      raise Eventsourcer::Errors::BrokerNotFound
    end

    private

    def self.broker
      raise Eventsourcer::Errors::BrokerNotConfiguredError unless Eventsourcer.configuration 
      config_broker = Eventsourcer.configuration.broker
      return config_broker.to_s.to_sym
    end
  end
end
