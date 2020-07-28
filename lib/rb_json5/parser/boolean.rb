# frozen_string_literal: true

module RbJSON5
  class Parser
    parse_rule(:boolean) do
      str('true').as(:true_literal) | str('false').as(:false_literal)
    end

    transform_rule(true_literal: simple(:_)) { true }
    transform_rule(false_literal: simple(:_)) { false }
  end
end
