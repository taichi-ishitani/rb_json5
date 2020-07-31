# frozen_string_literal: true

module RbJSON5
  class Parser
    {
      lf: "\u000a", cr: "\u000d",
      ls: "\u2028", ps: "\u2029"
    }.each do |name, code|
      parse_rule(name) { str(code) }
    end

    parse_rule(:line_terminator) do
      lf | cr | ls | ps
    end

    # list of character codes of white space
    WHITE_SPACE_CODES = [
      "\u0009", "\u000b", "\u000c", "\u0020", "\u00a0", "\ufeff"
    ].freeze

    parse_rule(:white_space) do
      WHITE_SPACE_CODES.map(&method(:str)).reduce(:|) |
        match('\\p{Space_Separator}')
    end

    parse_rule(:single_line_comment) do
      str('//') >> (line_terminator.absent? >> any).repeat
    end

    parse_rule(:multi_line_comment_chars) do
      (str('*').absent? >> any) | (str('*') >> str('/').absent?)
    end

    parse_rule(:multi_line_comment) do
      str('/*') >> multi_line_comment_chars.repeat >> str('*/')
    end

    parse_rule(:space?) do
      (
        white_space | line_terminator |
          single_line_comment | multi_line_comment
      ).repeat
    end
  end
end
