# frozen_string_literal: true

module RbJSON5
  class Parser
    parse_rule(:empty_array) do
      (str('[') >> str(']')).as(:empty_array)
    end

    parse_rule(:array_elements) do
      value >> (str(',') >> value).repeat >> str(',').maybe
    end

    parse_rule(:non_empty_array) do
      str('[') >> array_elements.as(:array_elements) >> str(']')
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
