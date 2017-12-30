module Eventsourcer
  class BrokerFactory
    def self.build
      case broker
      when :kafka
        return Eventsourcer::Brokers::KafkaBroker
      end
    end

    private

    def self.broker
      config_broker = Eventsourcer.configuration.broker
      raise Eventsourcer::Errors::BrokerNotConfiguredError unless config_broker 
      return config_broker.to_s.to_sym
    end
  end
end
