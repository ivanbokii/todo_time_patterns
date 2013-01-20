require_relative 'helper_modules'
require_relative 'tokens'
require_relative 'time_patterns'

class TimePatternsFinder
  def find_and_update(tokens)
    tokens_with_time = find_and_update_time tokens
    tokens_with_intervals = find_and_update_intervals tokens_with_time
    result = find_and_update_ending_forms tokens_with_intervals

    result
  end

  private
  def find_and_update_time(tokens)
    patterns = [ClassicTimeWithModifierPattern.new, ClassicTimePattern.new, 
      TimeWithModifierPattern.new]
    patterns.each { |pattern| tokens = pattern.find_and_update tokens }

    tokens
  end

  def find_and_update_intervals(tokens)
    patterns = [ComplexIntervalPattern.new, SimpleIntervalPattern.new]
    patterns.each { |pattern| tokens = pattern.find_and_update tokens }

    tokens
  end

  def find_and_update_ending_forms(tokens)
    patterns = [IntervalEndingPattern.new, IntervalTimeEndingPattern.new, 
      TimeEndingPattern.new]
    patterns.each { |pattern| tokens = pattern.find_and_update tokens }

    tokens
  end
end