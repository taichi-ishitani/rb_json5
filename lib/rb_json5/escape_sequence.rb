# frozen_string_literal: true

module RbJSON5
  # @api private
  # Utility class to unescape the given escape sequence
  class EscapeSequence
    # @param sequence [Parslet::Slice]
    #   escape sequence
    # @param valid_patterns [Array<Regexp>]
    #   list of patterns for valid unescaped character
    # @yield [character, sequence]
    #   call back block called when unespaced character is not matched
    #   with the given valid_patterns
    # @yieldparam character [String]
    #   character unescaped from the given escape sequence
    # @yieldparam sequence [Parslet::Slice]
    #   the given escape sequence
    def initialize(sequence, valid_patterns = [], &ifinvalid)
      @character = unescape(sequence.to_s)
      validate(@character, sequence, valid_patterns, ifinvalid)
    end

    # returns the character unescaped from the given escape sequence
    #
    # @return [String]
    #   unescaped character
    def to_s
      @character
    end

    private

    # list of charactors needing escape
    ESCAPE_CHARACTERS = {
      'b' => "\b", 'f' => "\f", 'n' => "\n",
      'r' => "\r", 't' => "\t", 'v' => "\v",
      '0' => "\0"
    }.freeze
    private_constant :ESCAPE_CHARACTERS

    def unescape(sequence)
      case sequence[1]
      when 'x' then sequence[2, 2].hex.chr(Encoding::UTF_8)
      when 'u' then unescape_unicode(sequence)
      else ESCAPE_CHARACTERS[sequence[1]] || sequence[1]
      end
    end

    # A surrogate pair (\uD83D\uDE00) is unescaped to one character.
    # An unpaired surrogate gives a string with invalid encoding.
    def unescape_unicode(sequence)
      high, low = sequence.scan(/\h{4}/).map(&:hex)
      code_point =
        (low && (0x10000 + ((high - 0xD800) << 10) + (low - 0xDC00))) || high
      [code_point].pack('U')
    end

    def validate(character, sequence, valid_patterns, ifinvalid)
      valid_character?(character, valid_patterns) ||
        ifinvalid&.call(character, sequence)
    end

    def valid_character?(character, valid_patterns)
      return false unless character.valid_encoding?

      valid_patterns.empty? ||
        valid_patterns.any? { |pattern| pattern.match?(character) }
    end
  end
end
