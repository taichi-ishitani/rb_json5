# frozen_string_literal: true

module RbJSON5
  class Parser
    parse_rule(:line_terminator_sequence) do
      (cr >> lf) | line_terminator
    end

    parse_rule(:character_espace_sequence) do
      (
        str('\\') >> (match('[1-9xu]') | line_terminator).absent? >> any
      ).as(:character_espace_sequence)
    end

    parse_rule(:hex_escape_sequence) do
      (
        str('\\') >> str('x') >> match('\\h').repeat(2, 2)
      ).as(:code_escape_sequence)
    end

    parse_rule(:unicode_escape_sequence) do
      (
        str('\\') >> str('u') >> match('\\h').repeat(4, 4)
      ).as(:code_escape_sequence)
    end

    parse_rule(:escape_sequence) do
      unicode_escape_sequence | hex_escape_sequence | character_espace_sequence
    end

    parse_rule(:line_continuation) do
      (
        str('\\') >> line_terminator_sequence
      ).as(:line_continuation)
    end

    parse_rule(:single_string_charactor) do
      line_continuation | escape_sequence | ls | ps |
        ((str("'") | str('\\') | line_terminator).absent? >> any)
    end

    parse_rule(:single_string_charactors) do
      str("'") >> single_string_charactor.repeat.as(:string_charactors) >> str("'")
    end

    parse_rule(:double_string_charactor) do
      line_continuation | escape_sequence | ls | ps |
        ((str('"') | str('\\') | line_terminator).absent? >> any)
    end

    parse_rule(:double_string_charactors) do
      str('"') >> double_string_charactor.repeat.as(:string_charactors) >> str('"')
    end

    parse_rule(:string) do
      single_string_charactors | double_string_charactors
    end

    ESCAPE_CHARACTERS = {
      'b' => "\b", 'f' => "\f", 'n' => "\n",
      'r' => "\r", 't' => "\t", 'v' => "\v",
      '0' => "\0"
    }.freeze

    transform_rule(character_espace_sequence: simple(:character)) do
      ESCAPE_CHARACTERS[character.str[1]] || character.str[1]
    end

    transform_rule(code_escape_sequence: simple(:sequence)) do
      instance_eval("\"#{sequence}\"", __FILE__, __LINE__)
    end

    transform_rule(line_continuation: simple(:_)) do
      ''
    end

    transform_rule(string_charactors: subtree(:characters)) do
      Array(characters).join
    end
  end
end
