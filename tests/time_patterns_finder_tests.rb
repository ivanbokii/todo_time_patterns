require 'minitest/autorun'

require_relative '../lib/parser'
require_relative '../lib/time_patterns_finder'

class TimePatternsFinderTests < MiniTest::Unit::TestCase
  # def test_find_and_update_for_time
  #   input = "Buy bread at 5pm"
  #   expected_tokens = "{word}{word}{word}{time}"

  #   parser = Parser.new
  #   tokens = parser.parse input

  #   time_patterns_finder = TimePatternsFinder.new
  #   tokens_with_time_patterns = time_patterns_finder.find_and_update tokens

  #   result = ""
  #   tokens_with_time_patterns.each { |token| result << token.to_s }
  #   assert_equal(expected_tokens, result)
  # end

  def test_time_with_modifier_pattern
    input = "Buy bread at 5pm and go shopping at 9pm"

    parser = Parser.new
    tokens = parser.parse input

    pattern = TimeWithModifierPattern.new
    result = pattern.find_and_update tokens

    assert_equal("{word}{word}{word}{time}{word}{word}{word}{word}{time}", result.to_s)
  end

  def test_time_with_modifier_pattern_and_invalid_entry
    input = "Buy bread at 5 pm and go shopping at 17pm"

    parser = Parser.new
    tokens = parser.parse input

    pattern = TimeWithModifierPattern.new
    result = pattern.find_and_update tokens

    assert_equal("{word}{word}{word}{time}{word}{word}{word}{word}{number}{word}", result.to_s)
  end

  def test_classic_time_pattern
    input = "Buy bread at 17:00 and go shopping at 12:00"

    parser = Parser.new
    tokens = parser.parse input

    pattern = ClassicTimePattern.new
    result = pattern.find_and_update tokens

    assert_equal("{word}{word}{word}{time}{word}{word}{word}{word}{time}", result.to_s)
  end

  def test_classic_time_pattern_and_invalid_entry
    input = "Buy bread at 17:00 and go shopping at 25:00"

    parser = Parser.new
    tokens = parser.parse input

    pattern = ClassicTimePattern.new
    result = pattern.find_and_update tokens

    assert_equal("{word}{word}{word}{time}{word}{word}{word}{word}{number}{symbol}{number}", result.to_s)
  end

  def test_classic_time_with_modifier_pattern
    input = "Buy bread at 12:00 pm and go shopping at 7:39am"

    parser = Parser.new
    tokens = parser.parse input

    pattern = ClassicTimeWithModifierPattern.new
    result = pattern.find_and_update tokens

    assert_equal("{word}{word}{word}{time}{word}{word}{word}{word}{time}", result.to_s)
  end

  def test_classic_time_with_modifier_pattern_and_invalid_entry
    input = "Buy bread at 12:00 pm and go shopping at 17:39am"

    parser = Parser.new
    tokens = parser.parse input

    pattern = ClassicTimeWithModifierPattern.new
    result = pattern.find_and_update tokens

    assert_equal("{word}{word}{word}{time}{word}{word}{word}{word}{number}{symbol}{number}{word}", result.to_s)
  end

  def test_simple_interval_pattern
    #todo implement different postfixes, like m, min, minutes, h, hour, hours
    input = "Meet with friend at 1pm for 30mins"

    parser = Parser.new
    tokens = parser.parse input

    pattern = SimpleIntervalPattern.new
    result = pattern.find_and_update tokens

    assert_equal("{word}{word}{word}{word}{number}{word}{word}{interval}", result.to_s)
  end

  def test_simple_interval_pattern_invalid_entry
    #todo implement different postfixes, like m, min, minutes, h, hour, hours
    input = "Meet with friend at 1pm for 30hours"

    parser = Parser.new
    tokens = parser.parse input

    pattern = SimpleIntervalPattern.new
    result = pattern.find_and_update tokens

    assert_equal("{word}{word}{word}{word}{number}{word}{word}{number}{word}", result.to_s)
  end

  def test_complex_interval_pattern
    input = "Breakfast for 1hour 23m"

    parser = Parser.new
    tokens = parser.parse input

    pattern = ComplexIntervalPattern.new
    result = pattern.find_and_update tokens    

    assert_equal("{word}{word}{interval}", result.to_s)
  end

  def test_complex_interval_pattern_invalid_entry
    input = "Breakfast for 1m 23m"

    parser = Parser.new
    tokens = parser.parse input

    pattern = ComplexIntervalPattern.new
    result = pattern.find_and_update tokens    

    assert_equal("{word}{word}{number}{word}{number}{word}", result.to_s)
  end
end