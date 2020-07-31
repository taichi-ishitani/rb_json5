# frozen_string_literal: true

module RbJSON5
  # @api private
  # JSON5 parser implementation using [Parslet](https://github.com/kschiess/parslet)
  #
  # Parsing process:
  # 1. parses a JSON5 string into the intermediate structure
  #    by using Parser.parser
  # 2. convert the intermediate structure into Ruby objects
  #    by using Parser.transform
  class Parser
    class << self
      include Parslet

      # returns the class to parse a JSON5 string
      def parser
        @parser ||= Class.new(Parslet::Parser)
      end

      # returns the class to convert the intermediate structure into Ruby objects
      def transform
        @transform ||= Class.new(Parslet::Transform)
      end

      private

      # defines a rule how to parse the given JSON5 string
      def parse_rule(rule_name, &body)
        parser.class_eval { rule(rule_name, &body) }
      end

      # defines a helper method within Parser.parser
      def parse_helper(helper_name, &body)
        parser.class_eval { define_method(helper_name, &body) }
      end

      # defines a rule hot to convert tht intermediate strucure into Ruby objects
      def transform_rule(expression, &body)
        transform.class_eval { rule(expression, &body) }
      end
    end

    # @param root [Symbol]
    #   specifies the root rule of the Parser for testing parpose
    def initialize(root = nil)
      @root = root
    end

    # parses a JSON5 string into the Ruby
    #
    # @param (see RbJSON5.parse)
    # @return (see RbJSON5.parse)
    #
    # @see RbJSON5.parse
    # @see RbJSON5.load_file
    def parse(json5, symbolize_names = false)
      tree = parser.parse(json5)
      transform.apply(tree, symbolize_names: symbolize_names)
    end

    private

    def parser
      parser = self.class.parser.new
      @root && parser.__send__(@root) || parser
    end

    def transform
      self.class.transform.new
    end

    parse_rule(:value) do
      null | boolean | string | number | array | object
    end

    parse_rule(:root) do
      space? >> value >> space?
    end
  end
end
