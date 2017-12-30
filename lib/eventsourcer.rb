require 'eventsourcer/version'
require 'eventsourcer/broker_factory'
require 'eventsourcer/errors'
require 'eventsourcer/brokers/base'
require 'eventsourcer/brokers/kafka_broker'

module Eventsourcer
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :broker, :logger, :kafka_seed_brokers, :kafka_max_queue_size

    def initialize
      @broker = nil
      @logger = nil
      @kafka_seed_brokers = nil
      @kafka_max_queue_size = nil
    end
  end

  def self.included(base)
    base.send :after_commit, :publish if base.respond_to?(:after_commit)
  end

  def publish
    @publisher ||= Eventsourcer::BrokerFactory.build
    @publisher.publish(table_name: self.class.table_name, previous_changes: previous_changes)
  end
end
