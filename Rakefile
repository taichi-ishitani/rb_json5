# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/clean'
require 'rspec/core/rake_task'

CLEAN << '.rspec_status'
CLEAN << 'Gemfile.lock'
CLEAN << 'coverage'

RSpec::Core::RakeTask.new(:spec)

desc 'run all RSpec exmaples and collect coverage'
task :coverage do
  ENV['COVERAGE'] = 'on'
  Rake::Task['spec'].execute
end

unless ENV.key?('CI')
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new(:rubocop)

  require 'bump/tasks'
end

task default: :spec
