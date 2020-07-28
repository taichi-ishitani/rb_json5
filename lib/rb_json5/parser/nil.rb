# frozen_string_literal: true

module RbJSON5
  class Parser
    parse_rule(:nil) do
      str('nil').as(:nil_literal)
    end

    transform_rule(nil_literal: simple(:_)) { nil }
  end
end
