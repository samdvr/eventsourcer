RSpec.describe Eventsourcer::Brokers::Base do
  describe ".publish" do
    it "raises NotImplementedError" do
      expect{ described_class.publish(table_name: "table", previous_changes: {}) }.to raise_error(NotImplementedError)
    end
  end
end