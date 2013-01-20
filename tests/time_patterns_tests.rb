require 'minitest/autorun'

require_relative '../lib/parser'
require_relative '../lib/time_patterns'

class TimePatternsFinderTests < MiniTest::Unit::TestCase
  def setup
    @modifiers = %w[am pm]
    @hour_postfixes = %w[h hour hours]
    @minute_postfixes = %w[m min mins minutes]
    @parser = Parser.new
  end

  def test_time_with_modifier_pattern
    @modifiers.each do |modifier|
      input = "Buy bread at 12#{modifier}"
      tokens = @parser.parse input

      pattern = TimeWithModifierPattern.new
      result = pattern.find_and_update tokens

      assert_equal("{word}{word}{word}{time}", result.to_s)
    end
  end

  def test_time_with_modifier_pattern_and_invalid_entry
    @modifiers.each do |modifier|
      input = "Buy bread at 17 #{modifier}"

      tokens = @parser.parse input

      pattern = TimeWithModifierPattern.new
      result = pattern.find_and_update tokens

      assert_equal("{word}{word}{word}{number}{word}", result.to_s)
    end
  end

  def test_classic_time_pattern
    input = "Buy bread at 17:00"

    tokens = @parser.parse input

    pattern = ClassicTimePattern.new
    result = pattern.find_and_update tokens

    assert_equal("{word}{word}{word}{time}", result.to_s)
  end

  def test_classic_time_pattern_and_invalid_entry
    input = "Buy bread at 25:00"

    tokens = @parser.parse input

    pattern = ClassicTimePattern.new
    result = pattern.find_and_update tokens

    assert_equal("{word}{word}{word}{number}{symbol}{number}", result.to_s)
  end

  def test_classic_time_with_modifier_pattern
    @modifiers.each do |modifier|
      input = "Buy bread at 7:10#{modifier}"

      tokens = @parser.parse input

      pattern = ClassicTimeWithModifierPattern.new
      result = pattern.find_and_update tokens

      assert_equal("{word}{word}{word}{time}", result.to_s)  
    end
  end

  def test_classic_time_with_modifier_pattern_and_invalid_entry
    @modifiers.each do |modifier|
      input = "Buy bread at 17:39 #{modifier}"

      tokens = @parser.parse input

      pattern = ClassicTimeWithModifierPattern.new
      result = pattern.find_and_update tokens

      assert_equal("{word}{word}{word}{number}{symbol}{number}{word}", result.to_s)
    end
  end

  def test_simple_interval_pattern
    @modifiers.each do |modifier|
      @minute_postfixes.each do |minutes|
        input = "Meeting at 1#{modifier} for 30#{minutes}"

        tokens = @parser.parse input

        pattern = SimpleIntervalPattern.new
        result = pattern.find_and_update tokens

        assert_equal("{word}{word}{number}{word}{word}{interval}", result.to_s)
      end
    end
  end

  def test_simple_interval_values
    input = "Meeting with Pixel at 1pm for 1 hour"

    tokens = @parser.parse input

    pattern = SimpleIntervalPattern.new
    result = pattern.find_and_update tokens

    assert_equal(60, result.last.minutes)
  end

  def test_simple_interval_pattern_invalid_entry
    input = "Meeting at 1pm for 30hours"

    tokens = @parser.parse input

    pattern = SimpleIntervalPattern.new
    result = pattern.find_and_update tokens

    assert_equal("{word}{word}{number}{word}{word}{number}{word}", result.to_s)
  end

  def test_complex_interval_pattern
    @hour_postfixes.each do |hours|
      @minute_postfixes.each do |minutes|
        input = "Breakfast for 1#{hours} 23#{minutes}"

        tokens = @parser.parse input

        pattern = ComplexIntervalPattern.new
        result = pattern.find_and_update tokens

        assert_equal("{word}{word}{interval}", result.to_s)
      end
    end
  end

  def test_complex_interval_pattern_invalid_entry
    input = "Breakfast for 1m 23m"

    parser = Parser.new
    tokens = parser.parse input

    pattern = ComplexIntervalPattern.new
    result = pattern.find_and_update tokens    

    assert_equal("{word}{word}{number}{word}{number}{word}", result.to_s)
  end

  def test_simple_time_ending
    input = "Breakfast at 17:00"

    parser = Parser.new
    tokens = parser.parse input

    pattern = ClassicTimePattern.new
    result = pattern.find_and_update tokens

    ending_pattern = TimeEndingPattern.new
    ending_result = ending_pattern.find_and_update result

    assert_equal("{word}{ending_form}", ending_result.to_s)
  end

  def test_interval_ending
    input = "Breakfast at 4pm for 1h 30mins"

    parser = Parser.new
    tokens = parser.parse input

    pattern = TimeWithModifierPattern.new
    result = pattern.find_and_update tokens
    interval_pattern = ComplexIntervalPattern.new
    result = interval_pattern.find_and_update result

    ending_pattern = IntervalEndingPattern.new
    ending_result = ending_pattern.find_and_update result

    assert_equal("{word}{ending_form}", ending_result.to_s)
  end

  def test_interval_with_time_ending
    input = "Breakfast from 4:00 to 9:43pm"

    parser = Parser.new
    tokens = parser.parse input

    pattern = ClassicTimeWithModifierPattern.new
    result = pattern.find_and_update tokens

    pattern = ClassicTimePattern.new
    result = pattern.find_and_update result

    ending_pattern = IntervalTimeEndingPattern.new
    ending_result = ending_pattern.find_and_update result

    assert_equal("{word}{ending_form}", ending_result.to_s)
  end
end