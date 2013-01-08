require 'minitest/autorun'

require_relative '../lib/parser'

class ParserTests < MiniTest::Unit::TestCase
  def test_parse_input_into_tokens
    input = "Buy bread at 17:00"
    expected_tokens = "{word}{word}{word}{number}{symbol}{number}"

    parser = Parser.new
    tokens = parser.parse input

    assert_equal(expected_tokens, tokens.to_s)
  end
end