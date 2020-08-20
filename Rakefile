# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/clean'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'yard'

CLEAN << '.rspec_status'
CLEAN << 'Gemfile.lock'
CLEAN << 'coverage'

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new(:rubocop)

YARD::Rake::YardocTask.new(:yard)

desc 'run all RSpec exmaples and collect coverage'
task :coverage do
  ENV['COVERAGE'] = 'on'
  Rake::Task['spec'].execute
end

task default: :spec
