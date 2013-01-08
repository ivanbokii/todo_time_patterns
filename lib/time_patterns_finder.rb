require_relative 'helper_modules'
require_relative 'tokens'
require_relative 'time_patterns'
require_relative 'interval_patterns'

class TimePatternsFinder
  def find_and_update(tokens)
    find_and_update_time tokens
    find_and_update_intervals tokens
  end

  private
  def find_and_update_time(tokens)
    patterns = [TimeWithModifierPattern.new, ClassicTimeWithModifier.new, 
      ClassicTimePattern.new]
    
    patterns.each { |pattern| pattern.find_and_update tokens }
  end

  def find_and_update_intervals(tokens)
    patterns = []
  end
end