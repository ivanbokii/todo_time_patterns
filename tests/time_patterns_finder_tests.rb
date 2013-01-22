require 'minitest/autorun'

require_relative '../lib/todo_time_patterns/parser'
require_relative '../lib/todo_time_patterns/time_patterns_finder'

class TimePatternsFinderTests < MiniTest::Unit::TestCase
  def setup
    @parser = TimePatterns::Parser.new
    @patterns_finder = TimePatterns::TimePatternsFinder.new
  end

  def test_simple_form
    input = "Meet Sergii at 4pm"

    tokens = @parser.parse input
    result = @patterns_finder.find_and_update tokens

    assert_equal("{word}{word}{ending_form}", result.to_s)
  end

  def test_interval
    input = "Meet Sergii at 4pm for 2 hours 30mins"

    tokens = @parser.parse input
    result = @patterns_finder.find_and_update tokens

    assert_equal("{word}{word}{ending_form}", result.to_s)
    assert_equal(150, result.last.interval)
  end

  def test_interval_with_time
    input = "Meet Sergii from 4pm to 18:23"

    tokens = @parser.parse input
    result = @patterns_finder.find_and_update tokens

    assert_equal("{word}{word}{ending_form}", result.to_s)
  end
end