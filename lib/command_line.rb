require_relative 'parser'
require_relative 'time_patterns_finder'

class CommandLine
  def parse(input)
    parser = Parser.new
    tokens = parser.parser input

    time_patterns_finder = TimePatternsFinder.new
    tokens_with_time_patterns = time_patterns_finder.find_and_update tokens

  end
end