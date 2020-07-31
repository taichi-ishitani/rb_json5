# frozen_string_literal: true

require 'parslet'
require_relative 'rb_json5/version'
require_relative 'rb_json5/parser'
require_relative 'rb_json5/parser/space'
require_relative 'rb_json5/parser/misc'
require_relative 'rb_json5/parser/null'
require_relative 'rb_json5/parser/boolean'
require_relative 'rb_json5/parser/number'
require_relative 'rb_json5/parser/string'
require_relative 'rb_json5/parser/array'
require_relative 'rb_json5/parser/object'

module RbJSON5
  def self.parse(json5, symbolize_names: false)
    Parser.new.parse(json5, symbolize_names)
  end

  def self.load_file(filename, symbolize_names: false)
    File.open(filename, 'r') do |f|
      parse(f.read, symbolize_names: symbolize_names)
    end
  end
end
