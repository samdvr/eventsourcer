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
end