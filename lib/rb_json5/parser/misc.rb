# frozen_string_literal: true

module RbJSON5
  class Parser
    parse_rule(:comma) do
      space? >> str(',') >> space?
    end

    parse_rule(:colon) do
      space? >> str(':') >> space?
    end

    parse_helper(:bra) do |c|
      str(c) >> space?
    end

    parse_helper(:cket) do |c|
      space? >> str(c)
    end
  end
end
