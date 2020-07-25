# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

desc 'run all RSpec exmaples and collect coverage'
task :coverage do
  ENV['COVERAGE'] = 'on'
  Rake::Task['spec'].execute
end

task default: :spec
