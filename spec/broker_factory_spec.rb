RSpec.describe Eventsourcer::BrokerFactory do
  describe ".build" do
    context "when broker is :kafka" do
      it "returns KafkaBroker" do
        Eventsourcer.configure { |config| config.broker = :kafka }
        allow(described_class).to receive(:borker).and_return(:kafka)
        expect(described_class.build).to eq(Eventsourcer::Brokers::KafkaBroker)
      end
    end
  end

  describe ".broker" do
    context "when broker is configured" do
      it "returns configured broker" do
        Eventsourcer.configure { |config| config.broker = :kafka }
        expect(described_class.broker).to eq(:kafka)
      end
    end

    context "when broker is not configured" do
      it "raises BrokerNotConfiguredError" do
        Eventsourcer.configure { |config| config.broker = nil }
        expect{ described_class.broker}.to raise_error(Eventsourcer::Errors::BrokerNotConfiguredError)
      end
    end
  end
end