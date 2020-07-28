# frozen_string_literal: true

module RbJSON5
  class Parser
    parse_rule(:null) do
      str('null').as(:null_literal)
    end

    transform_rule(null_literal: simple(:_)) { nil }
  end
end
