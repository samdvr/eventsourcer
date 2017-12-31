require 'eventsourcer/version'
require 'eventsourcer/configuration'
require 'eventsourcer/broker_factory'
require 'eventsourcer/errors'
require 'eventsourcer/brokers/base'
require 'eventsourcer/brokers/kafka_broker'

module Eventsourcer
  def self.included(base)
    base.send :after_commit, :publish if base.respond_to?(:after_commit)
  end

  def publish
    @publisher ||= Eventsourcer::BrokerFactory.build
    @publisher.publish(table_name: self.class.table_name, previous_changes: previous_changes)
  end
end
