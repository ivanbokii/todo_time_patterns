class IntervalPattern
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

        time_token = IntervalToken.new tokens_set
        
        #warning, modifying collection during its enumeration
        index = tokens.index tokens_set[0]
        tokens.delete_if {|token| tokens_set.include? token}
        tokens.insert index, time_token
      end
    end

    tokens
  end
end

class SimpleIntervalPattern < IntervalPattern
  def initialize
    super %w[{number} {word}]
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

class ComplexIntervalPattern < IntervalPattern
  
end