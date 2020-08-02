# frozen_string_literal: true

require 'bundler/setup'
require 'parslet/rig/rspec'
require 'stringio'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.order = :random
end

if ENV.key?('COVERAGE')
  require 'simplecov'
  SimpleCov.start
end

if ENV.key?('COVERAGE') && ENV.key?('CI')
  require 'simplecov-cobertura'
  SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter
end

JSON5_TESTS = File.expand_path('json5-tests', __dir__)

require 'rb_json5'
