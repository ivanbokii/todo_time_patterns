require_relative 'helper_modules'

class TimePattern
  def initialize(pattern_array, token_class)
    @pattern = pattern_array.join
    @number_of_pattern_tokens = pattern_array.length
    @token_class = token_class
  end

  def find_and_update(tokens)
    return unless tokens.to_s.include? @pattern

    tokens.each_cons(@number_of_pattern_tokens) do |tokens_set|
      break unless tokens_set.length == @number_of_pattern_tokens

      tokens_set.extend(TokensStringRepresentation)

      if tokens_set.to_s == @pattern
        next unless valid? tokens_set

        time_token = @token_class.new tokens_set
        
        #warning, modifying collection during its enumeration
        substitute_tokens tokens_set, time_token, tokens
      end
    end

    tokens
  end

  private
  def substitute_tokens(old, new, tokens)
    index = tokens.index old[0]
    tokens.delete_if {|token| old.include? token}
    tokens.insert index, new
  end
end

class TimeWithModifierPattern < TimePattern
  def initialize
    super(%w[{number} {word}], TimeToken)
  end

  def valid?(tokens_pair)
    hour, modifier = tokens_pair.map { |token| token.value }
    (0..12).include?(hour) and ["am", "pm"].include?(modifier)
  end
end

class ClassicTimePattern < TimePattern
  def initialize
    super(%w[{number} {symbol} {number}], TimeToken)
  end

  def valid?(tokens_triplet)
    hour, colon, minutes = tokens_triplet.map { |token| token.value }
    (0..23).include?(hour) and (0..59).include?(minutes) and colon == ":"
  end
end

class ClassicTimeWithModifierPattern < TimePattern
  def initialize
    super(%w[{number} {symbol} {number} {word}], TimeToken)
  end

  def valid?(tokens_quadruple)
    hour, colon, minutes, modifier = tokens_quadruple.map { |token| token.value }
    (0..12).include?(hour) and (0..59).include?(minutes) and colon == ":" and ["am", "pm"].include?(modifier)
  end
end

class ComplexIntervalPattern < TimePattern
  def initialize
    super(%w[{number} {word} {number} {word}], IntervalToken)
  end

  def valid?(tokens_quadruple)
    tokens = tokens_quadruple.each_slice(2).to_a
    interval_pair_valid?(tokens[0], true) and interval_pair_valid?(tokens[1], false)
  end

  private
  def interval_pair_valid?(tokens_pair, for_hours)
    modifier = tokens_pair[1].value

    if for_hours and %w[h hour hours].include? modifier
      hours = tokens_pair[0].value
      (0..23).include? hours
    elsif not for_hours and %w[m min mins minutes].include? modifier
      minutes = tokens_pair[0].value
      (0..59).include? minutes
    else
      false
    end
  end
end

class SimpleIntervalPattern < TimePattern
  def initialize
    super(%w[{number} {word}], IntervalToken)
  end

  def valid?(tokens_pair)
    modifier = tokens_pair[1].value

    if %w[h hour hours].include? modifier
      hours = tokens_pair[0].value
      (0..23).include? hours
    elsif %w[m min mins minutes].include? modifier
      minutes = tokens_pair[0].value
      (0..59).include? minutes
    else
      false    
    end
  end
end

class SimpleTimeEndingPattern < TimePattern
  def initialize
    super(%w[{word} {time}], SimpleTimeEndingToken)
  end

  def valid?(tokens_pair)
    tokens_pair.first.value == "at"
  end
end

class IntervalEndingPattern < TimePattern
  def initialize
    super(%w[{word} {time} {word} {interval}], IntervalEndingToken)
  end

  def valid?(tokens_quadruple)
    tokens_quadruple[0].value == "at" and tokens_quadruple[2].value == "for"
  end
end

class IntervalTimeEndingPattern < TimePattern
  def initialize
    super(%w[{word} {time} {word} {time}], IntervalTimeEndingToken)
  end

  def valid?(tokens_quadruple)
    tokens_quadruple[0].value == "from" and tokens_quadruple[2].value == "to"
  end
end