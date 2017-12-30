RSpec.describe Eventsourcer do
  it "has a version number" do
    expect(Eventsourcer::VERSION).not_to be nil
  end

  describe "#publish" do
    it "publishes changes to a broker" do
      publisher = double("Publisher")
      allow(publisher).to receive(:publish)
      allow(Eventsourcer::BrokerFactory).to receive(:build).and_return(publisher)
      expect(publisher).to receive(:publish).with(table_name: "table_name", previous_changes: {})
      
      class MyModel
        include Eventsourcer

        def self.table_name
          "table_name"
        end

        def previous_changes
          {}
        end
      end
      MyModel.new.publish 
    end
  end
end
