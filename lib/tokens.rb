require_relative 'helper_modules'

class WordToken
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def to_s
    "{word}"
  end
end

class NumberToken
  attr_reader :value

  def initialize(value)
    @value = Integer(value)
  end

  def to_s
    "{number}"
  end
end

class SymbToken
  attr_reader :value
  
  def initialize(value)
    @value = value
  end

  def to_s
    "{symbol}"
  end
end

class UnknownToken
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def to_s
    "{unknown}"
  end
end

class TimeToken
  def initialize(values)
    @values = values
    @values.extend(TokensStringRepresentation)
  end

  def to_s
    "{time}"
  end
end

class IntervalToken
  def initialize(values)
    @values = values
    @values.extend(TokensStringRepresentation)
  end

  def to_s
    "{interval}"
  end
end

class SimpleTimeEndingToken
  def initialize(values)
    @values = values
    @values.extend(TokensStringRepresentation)
  end

  def to_s
    "{ending_form}"
  end
end

class IntervalEndingToken
  def initialize(values)
    @values = values
    @values.extend(TokensStringRepresentation)
  end

  def to_s
    "{ending_form}"
  end
end

class IntervalTimeEndingToken
  def initialize(values)
    @values = values
    @values.extend(TokensStringRepresentation)
  end

  def to_s
    "{ending_form}"
  end
end