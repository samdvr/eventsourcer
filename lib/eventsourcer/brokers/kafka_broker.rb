require "securerandom"
require "json"
require "kafka"

module Eventsourcer
  module Brokers
    class KafkaBroker < Base
      @mutex = Mutex.new

      def self.publish(table_name:, previous_changes:)
        producer = client.async_producer(max_queue_size: Eventsourcer.configuration.kafka_max_queue_size || 10000)
        begin
          produce_to_kafka(producer, table_name, previous_changes.to_json)
        rescue Kafka::BufferOverflow
          producer.deliver_messages
          produce_to_kafka(producer, table_name, previous_changes.to_json)
        end

        producer.deliver_messages
        producer.shutdown
      end
      
      private

      def self.produce_to_kafka(producer, table_name, previous_changes_json)
        producer.produce(previous_changes_json,
                 topic: table_name)
      end

      def self.client
        @mutex.synchronize do
          @client ||= Kafka.new(
            seed_brokers: Eventsourcer.configuration.kafka_seed_brokers || ["localhost:9092"],
            logger: Eventsourcer.configuration.logger || Rails.logger
          )
        end
      end
    end
  end
end
