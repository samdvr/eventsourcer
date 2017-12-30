RSpec.describe Eventsourcer::BrokerFactory do
  describe ".build" do
    context "when broker is not configured" do
      it "raises BrokerNotFound" do
        expect{ described_class.build}.to raise_error(Eventsourcer::Errors::BrokerNotConfiguredError)
      end
    end

    context "when broker is :kafka" do
      it "returns KafkaBroker" do
        Eventsourcer.configure { |config| config.broker = :kafka }
        allow(described_class).to receive(:fetch_broker_klass).with(:kafka).and_return(Eventsourcer::Brokers::KafkaBroker)
        expect(described_class.build).to eq(Eventsourcer::Brokers::KafkaBroker)
      end
    end
  end

  describe ".fetch_broker_klass" do 
    context "when broker is configured" do
      it "returns configured broker" do
        Eventsourcer.configure { |config| config.broker = :kafka }
        expect(described_class.fetch_broker_klass(:kafka)).to eq(Eventsourcer::Brokers::KafkaBroker)

      end
    end

    context "when broker is not found" do
      it "raises BrokerNotFound" do
        Eventsourcer.configure { |config| config.broker = "" }
        expect{ described_class.fetch_broker_klass(nil)}.to raise_error(Eventsourcer::Errors::BrokerNotFound)
      end
    end
  end
end