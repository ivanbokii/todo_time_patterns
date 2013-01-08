require_relative 'helper_modules'

class TimePattern
  def initialize(pattern_array)
    @pattern = pattern_array.join
    @number_of_pattern_tokens = pattern_array.length
  end

  def find_and_update(tokens)
    return unless tokens.to_s.include? @pattern

    tokens.each_cons(@number_of_pattern_tokens) do |tokens_set|
      break unless tokens_set.length == @number_of_pattern_tokens

      tokens_set.extend(TokensStringRepresentation)

      if tokens_set.to_s == @pattern
        next unless valid? tokens_set

        time_token = TimeToken.new tokens_set
        
        #warning, modifying collection during its enumeration
        index = tokens.index tokens_set[0]
        tokens.delete_if {|token| tokens_set.include? token}
        tokens.insert index, time_token
      end
    end

    tokens
  end
end

class TimeWithModifierPattern < TimePattern
  def initialize
    super %w[{number} {word}]
  end

  def valid?(tokens_pair)
    hour, modifier = tokens_pair.map { |token| token.value }
    (0..12).include?(hour) and ["am", "pm"].include?(modifier)
  end
end

class ClassicTimePattern < TimePattern
  def initialize
    super %w[{number} {symbol} {number}]
  end

  def valid?(tokens_triplet)
    hour, colon, minutes = tokens_triplet.map { |token| token.value }
    (0..23).include?(hour) and (0..59).include?(minutes) and colon == ":"
  end
end

class ClassicTimeWithModifierPattern < TimePattern
  def initialize
    super %w[{number} {symbol} {number} {word}]
  end

  def valid?(tokens_quadruple)
    hour, colon, minutes, modifier = tokens_quadruple.map { |token| token.value }
    (0..12).include?(hour) and (0..59).include?(minutes) and colon == ":" and ["am", "pm"].include?(modifier)
  end
end