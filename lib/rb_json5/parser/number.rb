# frozen_string_literal: true

module RbJSON5
  class Parser
    parse_rule(:decimal_digit) do
      match('[0-9]')
    end

    parse_rule(:non_zero_digit) do
      match('[1-9]')
    end

    parse_rule(:sign?) do
      (str('+') | str('-')).maybe
    end

    parse_rule(:decimal_digits) do
      decimal_digit.repeat(1)
    end

    parse_rule(:decimal_digits?) do
      decimal_digit.repeat
    end

    parse_rule(:exponent_part) do
      match('[Ee]') >> sign? >> decimal_digits
    end

    parse_rule(:exponent_part?) do
      exponent_part.maybe
    end

    parse_rule(:decimal_integer_literal) do
      (non_zero_digit >> decimal_digits?) | decimal_digit
    end

    parse_rule(:decimal_fractional_literal) do
      (decimal_integer_literal >> str('.') >> decimal_digits? >> exponent_part?) |
        (str('.') >> decimal_digits >> exponent_part?) |
        (decimal_integer_literal >> exponent_part)
    end

    parse_rule(:hex_integer_literal) do
      str('0') >> match('[Xx]') >> match('\\h').repeat(1)
    end

    parse_rule(:integer_number) do
      (sign? >> (hex_integer_literal | decimal_integer_literal)).as(:integer_number)
    end

    parse_rule(:fractional_number) do
      (sign? >> decimal_fractional_literal).as(:fractional_number)
    end

    parse_rule(:infinity_literal) do
      (sign? >> str('Infinity')).as(:infinity_literal)
    end

    parse_rule(:nan_literal) do
      (sign? >> str('NaN')).as(:nan_literal)
    end

    parse_rule(:number) do
      nan_literal | infinity_literal | fractional_number | integer_number
    end

    transform_rule(integer_number: simple(:n)) { Integer(n.str) }

    transform_rule(fractional_number: simple(:n)) { n.to_f }

    transform_rule(infinity_literal: simple(:n)) do
      n.str[0] == '-' && -Float::INFINITY || Float::INFINITY
    end

    transform_rule(nan_literal: simple(:n)) { Float::NAN }
  end
end
