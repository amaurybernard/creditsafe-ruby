# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "creditsafe/version"

Gem::Specification.new do |spec|
  spec.name          = "creditsafe"
  spec.version       = Creditsafe::VERSION
  spec.authors       = ["GoCardless Engineering", "Amaury Bernard for AH3"]
  spec.email         = ["engineering@gocardless.com"]
  spec.summary       = "Ruby client for the Creditsafe REST API"
  spec.homepage      = "https://github.com/gocardless/creditsafe-ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activesupport", ">= 4.2.0"
  spec.add_runtime_dependency "httparty"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "gc_ruboconfig", "~> 2.3"
  spec.add_development_dependency "pry", "~> 0.11"
  spec.add_development_dependency "rspec", "~> 3.1"
  spec.add_development_dependency "rspec-its", "~> 1.2"
  spec.add_development_dependency "rspec_junit_formatter", "~> 0.3"
  spec.add_development_dependency "rubocop", "~> 0.52"
  spec.add_development_dependency "timecop", "~> 0.8"
  spec.add_development_dependency "webmock", "~> 3.3"
end
