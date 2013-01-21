require_relative 'parser'
require_relative 'time_patterns_finder'

class CommandLine
  def parse(input)
    parser = Parser.new
    tokens = parser.parse input

    time_patterns_finder = TimePatternsFinder.new
    tokens_with_time_patterns = time_patterns_finder.find_and_update tokens

    result = generate_result(tokens_with_time_patterns, input)

    result
  end

  def remove_from_input(input, tokens)
    
  end

  def generate_result(tokens, input)
    time_token = tokens.find {|token| token.to_s == "{ending_form}"}

    unless time_token.nil?
      time_token = tokens.find {|token| token.to_s == "{ending_form}"}
      to_remove = input.slice(time_token.start_index, time_token.end_index - time_token.start_index + 2)

      {
        hours: time_token.hours,
        minutes: time_token.minutes,
        interval: time_token.interval,
        result_string: input.sub(to_remove, "").strip
      }
    else
      nil
    end
  end
end