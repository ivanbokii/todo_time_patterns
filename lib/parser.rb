require_relative 'parser_helpers'
require_relative 'tokens'
require_relative 'helper_modules'

class Parser
  def initialize
    @parser_checks = {
      letter?: WordToken,
      number?: NumberToken,
      symbol?: SymbToken,
      unknown?: UnknownToken
    }
  end

  def parse(input)

    i = 0
    buffer = ""
    tokens = []

    while input[i]
      break if input[i] == nil

      while input[i] == " "
        i += 1
      end

      @parser_checks.each do |check_method, check_class|
        while input[i] != nil and input[i] != " " and input[i].send check_method
          buffer << input[i]
          i += 1
        end

        unless buffer.empty?
          tokens << (check_class.new buffer)
          buffer = ""
        end
      end
    end

    tokens.extend(TokensStringRepresentation)
    tokens
  end
end