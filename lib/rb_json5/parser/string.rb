# frozen_string_literal: true

module RbJSON5
  class Parser
    parse_rule(:line_terminator_sequence) do
      (cr >> lf) | line_terminator
    end

    parse_rule(:character_escape_sequence) do
      str('\\') >> (match('[0-9xu]') | line_terminator).absent? >> any
    end

    parse_rule(:null_escape_sequence) do
      str('\\') >> str('0') >> match('[1-9]').absent?
    end

    parse_rule(:hex_escape_sequence) do
      str('\\') >> str('x') >> match('\\h').repeat(2, 2)
    end

    parse_rule(:unicode_escape_sequence) do
      str('\\') >> str('u') >> match('\\h').repeat(4, 4)
    end

    parse_rule(:escape_sequence) do
      (
        hex_escape_sequence | unicode_escape_sequence |
          null_escape_sequence | character_escape_sequence
      ).as(:escape_sequence)
    end

    parse_rule(:line_continuation) do
      (
        str('\\') >> line_terminator_sequence
      ).as(:line_continuation)
    end

    parse_rule(:single_string_normal_charactor) do
      (
        ls | ps |
        ((str("'") | str('\\') | line_terminator).absent? >> any)
      ).as(:normal_charactor)
    end

    parse_rule(:single_string_charactor) do
      line_continuation | escape_sequence | single_string_normal_charactor
    end

    parse_rule(:single_string_charactors) do
      str("'") >> single_string_charactor.repeat.as(:string_charactors) >> str("'")
    end

    parse_rule(:double_string_normal_charactor) do
      (
        ls | ps |
        ((str('"') | str('\\') | line_terminator).absent? >> any)
      ).as(:normal_charactor)
    end

    parse_rule(:double_string_charactor) do
      line_continuation | escape_sequence | double_string_normal_charactor
    end

    parse_rule(:double_string_charactors) do
      str('"') >> double_string_charactor.repeat.as(:string_charactors) >> str('"')
    end

    parse_rule(:string) do
      single_string_charactors | double_string_charactors
    end

    transform_rule(escape_sequence: simple(:sequence)) do
      EscapeSequence.new(sequence)
    end

    transform_rule(line_continuation: simple(:_)) do
      ''
    end

    transform_rule(normal_charactor: simple(:character)) do
      character.to_s
    end

    transform_rule(string_charactors: subtree(:characters)) do
      Array(characters).join
    end
  end
end
