# Eventsourcer

A helper library for event sourcing Rails ActiveRecord model changes to Kafka(more brokers coming soon).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'eventsourcer'
```

And then execute:

    $ bundle

## Usage

In initializer configure Eventsourcer:
```ruby
  Eventsourcer.configure do |config|
    config.broker = :kafka #required
    config.kafka_seed_brokers = ["localhost:9092"] #optional
    config.kafka_max_queue_size = 10000 #optional
  end
```

Add Eventsourcer to a model you would like to track:
```ruby
  require "eventsourcer"
  class User < ApplicationRecord
    include Eventsourcer
  end
```

## Kafka Broker
Events generated for Kafka are published to ActiveRecord model's table name topic.
For example
```ruby
  require "eventsourcer"
  class User < ApplicationRecord
    include Eventsourcer
  end
```
will publish messages to 'users' topic.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/samdvr/eventsourcer.
