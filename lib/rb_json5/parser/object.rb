# frozen_string_literal: true

module RbJSON5
  class Parser
    parse_rule(:unicode_letter) do
      match('\\p{Letter}') | match('\\p{Letter_Number}')
    end

    parse_rule(:unicode_combining_mark) do
      match('\\p{Nonspacing_Mark}') | match('\\p{Spacing_Mark}')
    end

    parse_rule(:unicode_digit) do
      match('\\p{Decimal_Number}')
    end

    parse_rule(:unicode_connector_punctuation) do
      match('\\p{Connector_Punctuation}')
    end

    parse_rule(:identifier_start) do
      str('$') | str('_') | unicode_escape_sequence | unicode_letter
    end

    parse_rule(:identifier_part) do
      identifier_start | unicode_combining_mark | unicode_digit |
        unicode_connector_punctuation | str("\u200c") | str("\u200d")
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

    # @api private
    # structure to keep a name/value pair for JSON5Object
    ObjectMember = Struct.new(:name, :value)

    transform_rule(identifier_name: subtree(:name)) do
      Array(name).join
    end

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
