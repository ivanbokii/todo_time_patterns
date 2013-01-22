require_relative 'todo_time_patterns/parser'
require_relative 'todo_time_patterns/time_patterns_finder'

class TodoTimePatterns
  def self.parse(input)
    parser = TimePatterns::Parser.new
    tokens = parser.parse input

    time_patterns_finder = TimePatterns::TimePatternsFinder.new
    tokens_with_time_patterns = time_patterns_finder.find_and_update tokens

    result = generate_result(tokens_with_time_patterns, input)

    result
  end

  def self.generate_result(tokens, input)
    time_token = tokens.find {|token| token.to_s == "{ending_form}"}

    unless time_token.nil?
      time_token = tokens.find {|token| token.to_s == "{ending_form}"}
      to_remove = input.slice(time_token.start_index, time_token.end_index - time_token.start_index + 1)

      {
        hours: time_token.hours,
        minutes: time_token.minutes,
        interval: time_token.interval,
        result_string: input.sub(to_remove, "").sub("  ", " ").strip
      }
    else
      nil
    end
  end

  private_class_method :generate_result
end