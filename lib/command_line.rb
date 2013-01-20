require_relative 'parser'
require_relative 'time_patterns_finder'

class CommandLine
  def parse(input)
    parser = Parser.new
    tokens = parser.parse input

    time_patterns_finder = TimePatternsFinder.new
    tokens_with_time_patterns = time_patterns_finder.find_and_update tokens

    generate_result tokens_with_time_patterns
  end

  def generate_result(tokens)
    time_token = tokens.find {|token| token.to_s == "{ending_form}"}

    {
      hours: time_token.hours,
      minutes: time_token.minutes,
      interval: time_token.interval
    }
  end
end