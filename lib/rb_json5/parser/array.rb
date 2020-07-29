# frozen_string_literal: true

module RbJSON5
  class Parser
    parse_rule(:empty_array) do
      (bra('[') >> cket(']')).as(:empty_array)
    end

    parse_rule(:array_elements) do
      value >> (comma >> value).repeat >> comma.maybe
    end

    parse_rule(:non_empty_array) do
      bra('[') >> array_elements.as(:array_elements) >> cket(']')
    end

    parse_rule(:array) do
      empty_array | non_empty_array
    end

    transform_rule(empty_array: simple(:_)) { [] }

    transform_rule(array_elements: subtree(:elements)) do
      elements.is_a?(Array) && elements || [elements]
    end
  end
end
