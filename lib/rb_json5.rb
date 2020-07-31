# frozen_string_literal: true

require 'parslet'
require_relative 'rb_json5/version'
require_relative 'rb_json5/parse_error'
require_relative 'rb_json5/escape_sequence'
require_relative 'rb_json5/parser'
require_relative 'rb_json5/parser/space'
require_relative 'rb_json5/parser/misc'
require_relative 'rb_json5/parser/null'
require_relative 'rb_json5/parser/boolean'
require_relative 'rb_json5/parser/number'
require_relative 'rb_json5/parser/string'
require_relative 'rb_json5/parser/array'
require_relative 'rb_json5/parser/object'

# [JSON5](https://json5.org/) parser for Ruby
module RbJSON5
  # Parses a JSON5 string into its Ruby data structure
  #
  # @param json5 [String]
  #   JSON5 string
  # @param symbolize_names [Boolean]
  #   If set to true, converts names (keys) in a JSON5 object into Symbol
  # @return [Object]
  #   Ruby data structure represented by the input
  #
  # @see RbJSON5.load_file
  def self.parse(json5, symbolize_names: false)
    Parser.new.parse(json5, symbolize_names)
  end

  # Reads a JSON5 string from the given file and parses it into its Ruby data structure
  #
  # @param filename [String]
  #   name of the given file
  # @param symbolize_names [Boolean]
  #   If set to true, converts names (keys) in a JSON5 object into Symbol
  # @return [Object]
  #   Ruby data structure represented by the input
  #
  # @see RbJSON5.parse
  def self.load_file(filename, symbolize_names: false)
    File.open(filename, 'r') do |f|
      parse(f.read, symbolize_names: symbolize_names)
    end
  end
end
