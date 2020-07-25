# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.include?(lib) || $LOAD_PATH.unshift(lib)
require 'rb_json5/version'

Gem::Specification.new do |spec|
  spec.name          = 'rb_json5'
  spec.version       = RbJSON5::VERSION
  spec.authors       = ['Taichi Ishitani']
  spec.email         = ['taichi730@gmail.com']

  spec.summary       = 'JSON5 parser for Ruby'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/taichi-ishitani/rb_json5'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.4.0')

  spec.metadata['bug_tracker_uri'] = 'https://github.com/taichi-ishitani/rb_json5/issues'
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage

  spec.files =
    `git ls-files lib LICENSE CODE_OF_CONDUCT.md README.md`.split($RS)
  spec.require_paths = ['lib']
end
