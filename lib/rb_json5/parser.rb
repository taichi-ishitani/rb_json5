# frozen_string_literal: true

module RbJSON5
  class Parser
    class << self
      include Parslet

      def parser
        @parser ||= Class.new(Parslet::Parser)
      end

      def transform
        @transform ||= Class.new(Parslet::Transform)
      end

      private

      def parse_rule(rule_name, &body)
        parser.class_eval { rule(rule_name, &body) }
      end

      def parse_helper(helper_name, &body)
        parser.class_eval { define_method(helper_name, &body) }
      end

      def transform_rule(expression, &body)
        transform.class_eval { rule(expression, &body) }
      end
    end

    def initialize(root = nil)
      @root = root
    end

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
