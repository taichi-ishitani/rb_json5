# frozen_string_literal: true

module RbJSON5
  class Parser
    # list of patterns for start character of identifier
    IDENTIFIER_START_PATTERNS = [
      /[$_]/, /\p{Letter}/, /\p{Letter_Number}/
    ].freeze

    # list of patterns for part character of identifier
    IDENTIFIER_PART_PATTERNS = [
      /[\u200c\u200d]/,
      /\p{Nonspacing_Mark}/, /\p{Spacing_Mark}/,
      /\p{Decimal_Number}/, /\p{Connector_Punctuation}/,
      *IDENTIFIER_START_PATTERNS
    ].freeze

    parse_helper(:compile_identifier_rule) do |patterns|
      patterns
        .map { |pattern| match(pattern.to_s) }
        .reduce(:|)
    end

    parse_rule(:unicode_identifier_start) do
      unicode_escape_sequence.as(:unicode_identifier_start)
    end

    parse_rule(:identifier_start) do
      unicode_identifier_start |
        compile_identifier_rule(IDENTIFIER_START_PATTERNS)
    end

    parse_rule(:unicode_identifier_part) do
      unicode_escape_sequence.as(:unicode_identifier_part)
    end

    parse_rule(:identifier_part) do
      unicode_identifier_part |
        compile_identifier_rule(IDENTIFIER_PART_PATTERNS)
    end

    parse_rule(:identifier_name) do
      (identifier_start >> identifier_part.repeat).as(:identifier_name)
    end

    parse_rule(:object_member) do
      (
        (identifier_name | string).as(:key) >> colon >> value.as(:value)
      ).as(:object_member)
    end

    parse_rule(:object_members) do
      object_member >> (comma >> object_member).repeat >> comma.maybe
    end

    parse_rule(:non_empty_object) do
      bra('{') >> object_members.as(:object_members) >> cket('}')
    end

    parse_rule(:empty_object) do
      (bra('{') >> cket('}')).as(:empty_object)
    end

    parse_rule(:object) do
      empty_object | non_empty_object
    end

    transform_rule(unicode_identifier_start: simple(:sequence)) do
      EscapeSequence.new(sequence, IDENTIFIER_START_PATTERNS) do |character|
        Parslet::Cause.format(
          sequence.line_cache, sequence.position.bytepos,
          "#{character.inspect} cannot be used for identifier"
        ).raise
      end
    end

    transform_rule(unicode_identifier_part: simple(:sequence)) do
      EscapeSequence.new(sequence, IDENTIFIER_PART_PATTERNS) do |character|
        Parslet::Cause.format(
          sequence.line_cache, sequence.position.bytepos,
          "#{character.inspect} cannot be used for identifier"
        ).raise
      end
    end

    transform_rule(identifier_name: subtree(:name)) do
      Array(name).join
    end

    # @api private
    # structure to keep a name/value pair for JSON5Object
    ObjectMember = Struct.new(:name, :value)

    transform_rule(object_member: { key: simple(:key), value: subtree(:value) }) do
      ObjectMember.new(symbolize_names && key.to_sym || key.to_s, value)
    end

    transform_rule(object_members: subtree(:members)) do
      (members.is_a?(Array) && members || [members]).map(&:to_a).to_h
    end

    transform_rule(empty_object: simple(:_)) do
      {}
    end
  end
end
