# frozen_string_literal: true

require File.expand_path('lib/rb_json5/version', __dir__)

Gem::Specification.new do |spec|
  spec.name = 'rb_json5'
  spec.version = RbJSON5::VERSION
  spec.authors = ['Taichi Ishitani']
  spec.email = ['taichi730@gmail.com']

  spec.summary = 'JSON5 parser for Ruby'
  spec.description = spec.summary
  spec.homepage = 'https://github.com/taichi-ishitani/rb_json5'
  spec.license = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.4.0')

  spec.metadata['bug_tracker_uri'] = 'https://github.com/taichi-ishitani/rb_json5/issues'
  spec.metadata['documentation_uri'] = 'https://www.rubydoc.info/gems/rb_json5'
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage

  spec.files =
    `git ls-files lib LICENSE CODE_OF_CONDUCT.md README.md .yardopts`.split($RS)
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'parslet', '~> 2.0'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'redcarpet', '~> 3.5.0'
  spec.add_development_dependency 'rspec', '~> 3.9.0'
  spec.add_development_dependency 'rubocop', '~> 0.88.0'
  spec.add_development_dependency 'simplecov', '~> 0.18.0'
  spec.add_development_dependency 'simplecov-cobertura', '~> 1.3.0'
  spec.add_development_dependency 'yard', '~> 0.9.0'
end
