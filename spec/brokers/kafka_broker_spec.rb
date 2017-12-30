RSpec.describe Eventsourcer::Brokers::KafkaBroker do
  let(:client) { Kafka.new(seed_brokers: ["localhost:9092"]) }
  let(:producer) { double("AsyncProducer") }

  before do
    allow(described_class).to receive(:client).and_return(client)
    allow(client).to receive(:async_producer).and_return(producer)
    allow(producer).to receive(:produce)
    allow(producer).to receive(:deliver_messages)
    allow(producer).to receive(:shutdown)
  end

  describe ".publish" do
    context "when kafka_max_queue_size is set" do
      it "creates an async kafka producer with kafka_max_queue_size" do
        Eventsourcer.configure do
        end        
        expect(client).to receive(:async_producer).with({max_queue_size: 10000})
        described_class.publish(table_name: "table_name", previous_changes: {})
      end
    end

    context "when kafka_max_queue_size is not set" do
      it "creates an async kafka producer with 10000 as max_queue_size" do
        Eventsourcer.configure do |config|
          config.kafka_max_queue_size = 10
        end

        expect(client).to receive(:async_producer).with({max_queue_size: 10})
        described_class.publish(table_name: "table_name", previous_changes: {})
      end
    end

    it "produces messages to kafka" do
      Eventsourcer.configure { }
      expect(described_class).to receive(:produce_to_kafka).with(producer, "table_name", "{}")
      described_class.publish(table_name: "table_name", previous_changes: {})
    end

    it "delivers messages" do
      Eventsourcer.configure { }
      expect(producer).to receive(:deliver_messages)
      described_class.publish(table_name: "table_name", previous_changes: {})
    end

    it "shuts down kafka client" do
      Eventsourcer.configure { }
      expect(producer).to receive(:shutdown)
      described_class.publish(table_name: "table_name", previous_changes: {})
    end
  end

  describe ".produce_to_kafka" do
    it "enqueues messages to kafka queue" do
      Eventsourcer.configure { }
      allow(SecureRandom).to receive(:uuid).and_return("881791e3-969a-4699-9c67-5fcdb756ece3")
      expect(producer).to receive(:produce).with({}, topic: "table_name", key: "881791e3-969a-4699-9c67-5fcdb756ece3")
      described_class.send(:produce_to_kafka, producer, "table_name", {})
    end
  end

  describe ".client" do
    context "when seedbrokers and logger values have not been configured" do
      it "uses the defaults for KafkaClient" do
        client = Kafka.new(seed_brokers: ["localhost:9092"])
        expect(client.instance_variable_get(:@logger)).not_to eq(nil)
        broker_seeds = client.instance_variable_get(:@seed_brokers)
        expect(broker_seeds.first.hostname).to eq("localhost")
        expect(broker_seeds.first.port).to eq(9092)
      end
    end

    context "when seedbrokers and logger values have been configured" do
      it "passes the config values to KafkaClient" do
        client = Kafka.new(seed_brokers: ["google:9092"])
        Eventsourcer.configure do |config|
          config.kafka_seed_brokers = ["google.com:9092"]
          config.logger = Class.new
        end

        expect(client.instance_variable_get(:@logger)).not_to eq(nil)
        broker_seeds = client.instance_variable_get(:@seed_brokers)
        expect(broker_seeds.first.hostname).to eq("google")
        expect(broker_seeds.first.port).to eq(9092)
      end
    end
  end
end