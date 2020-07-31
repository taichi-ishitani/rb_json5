# frozen_string_literal: true

module RbJSON5
  # @api private
  # Utility class to unescape the given escape sequence
  class EscapeSequence
    # @param sequence [Parslet::Slice]
    #   escape sequence
    # @param valid_patterns [Array<Regexp>]
    #   list of patterns for valid unescaped character
    # @param ifinvalid [Proc]
    #   call back block called when unespaced character is not matched
    #   with the given valid_patterns
    def initialize(sequence, valid_patterns = [], &ifinvalid)
      @character = unescape(sequence.to_s, valid_patterns, ifinvalid)
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

    def unescape(sequence, valid_patterns, ifinvalid)
      character =
        if ['x', 'u'].include?(sequence[1])
          "\"#{sequence}\"".undump
        else
          ESCAPE_CHARACTERS[sequence[1]] || sequence[1]
        end
      valid_character?(character, valid_patterns) &&
        character || ifinvalid.call(character)
    end

    def valid_character?(character, valid_patterns)
      valid_patterns.empty? ||
        valid_patterns.any? { |pattern| pattern.match?(character) }
    end
  end
end
