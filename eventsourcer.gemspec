lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "eventsourcer/version"

Gem::Specification.new do |spec|
  spec.name          = "eventsourcer"
  spec.version       = Eventsourcer::VERSION
  spec.authors       = ["Sam Davarnia"]

  spec.summary       = %q{Library to event source ActiveRecord changes to a broker.}
  spec.description   = %q{This library publishes tracked ActiveRecord changes to a persistence layer such as Apache Kafka.}
  spec.homepage      = "https://github.com/samdvr/eventsourcer"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_dependency "ruby-kafka", "~> 0.5"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
