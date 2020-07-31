# frozen_string_literal: true

module RbJSON5
  # Exception class raised when the parse failed to match
  class ParseError < Parslet::ParseFailed
  end
end
