require_relative 'helper_modules'

module TimePatterns
  class WordToken
    attr_reader :value
    attr_reader :start_index

    def initialize(value, start_index)
      @value = value
      @start_index = start_index
    end

    def to_s
      "{word}"
    end
  end

  class NumberToken
    attr_reader :value
    attr_reader :start_index

    def initialize(value, start_index)
      @value = Integer(value)
      @start_index = start_index
    end

    def to_s
      "{number}"
    end
  end

  class SymbToken
    attr_reader :value
    attr_reader :start_index
    
    def initialize(value, start_index)
      @value = value
      @start_index = start_index
    end

    def to_s
      "{symbol}"
    end
  end

  class UnknownToken
    attr_reader :value
    attr_reader :start_index

    def initialize(value, start_index)
      @value = value
      @start_index = start_index
    end

    def to_s
      "{unknown}"
    end
  end

  class TimeToken
    attr_reader :start_index
    attr_reader :end_index

    attr_reader :hours
    attr_reader :minutes

    def initialize(values)
      @values = values
      @values.extend(TokensStringRepresentation)

      set_start_and_end_indexes values
      set_hours_and_minutes values
    end

    def to_s
      "{time}"
    end

    private
    def set_start_and_end_indexes(values)
      @start_index = values.first.start_index
      @end_index = values.last.start_index + values.last.value.to_s.length - 1
    end

    def set_hours_and_minutes(values)
      pattern = values.join

      case pattern
      when "{number}{word}" then set_time_values(values[0].value, 0, values[1].value)
      when "{number}{symbol}{number}" then set_time_values(values[0].value, values[2].value)
      when "{number}{symbol}{number}{word}" then set_time_values(values[0].value, values[2].value, values[3].value)
      end
    end

    def set_time_values(hours, minutes, modifier = "am")
      #3pm
      #17:00
      #13:00pm

      if modifier == "am"
        if hours == 12
          @hours = 0
        else
          @hours = hours
        end
      elsif modifier == "pm"
        if hours == 12
          @hours = 12
        else
          @hours = hours + 12
        end
      end

      @minutes = minutes
    end
  end

  class IntervalToken
    attr_reader :start_index
    attr_reader :end_index
    attr_reader :minutes

    def initialize(values)
      @values = values
      @values.extend(TokensStringRepresentation)

      set_start_and_end_indexes values
      set_minutes values
    end

    def to_s
      "{interval}"
    end

    private
    def set_start_and_end_indexes(values)
      @start_index = values.first.start_index
      @end_index = values.last.start_index + values.last.value.to_s.length - 1
    end

    def set_minutes(values)
      #1h 30mins
      #20mins
      #1 hour

      pattern = values.join

      @minutes = 0
      if pattern == "{number}{word}"
        if %w[h hour hours].include? values[1].value
          @minutes = values[0].value * 60
        else
          @minutes = values[0].value
        end
      elsif pattern == "{number}{word}{number}{word}"
        hours = values[0].value
        @minutes = values[2].value + hours * 60
      end
    end
  end

  class TimeEndingToken
    attr_reader :start_index
    attr_reader :end_index
    attr_reader :hours
    attr_reader :minutes
    attr_reader :interval

    def initialize(values)
      @interval = 0
      @values = values
      @values.extend(TokensStringRepresentation)

      set_start_and_end_indexes values
      set_minutes values
    end

    def to_s
      "{ending_form}"
    end
    
    private
    def set_start_and_end_indexes(values)
      @start_index = values.first.start_index
      @end_index = values.last.end_index
    end

    def set_minutes(values)
      time = values[1]
      @minutes = time.minutes
      @hours = time.hours
    end
  end

  class IntervalEndingToken
    attr_reader :start_index
    attr_reader :end_index
    attr_reader :minutes
    attr_reader :hours
    attr_reader :interval

    def initialize(values)
      @values = values
      @values.extend(TokensStringRepresentation)

      set_start_and_end_indexes values
      set_time_and_interval values
    end

    def set_start_and_end_indexes(values)
      @start_index = values.first.start_index
      @end_index = values.last.end_index
    end

    def set_time_and_interval(values)
      time = values[1]
      @minutes = time.minutes
      @hours = time.hours

      @interval = values[3].minutes
    end

    def to_s
      "{ending_form}"
    end
  end

  class IntervalTimeEndingToken
    attr_reader :start_index
    attr_reader :end_index
    attr_reader :minutes
    attr_reader :hours
    attr_reader :interval

    def initialize(values)
      @values = values
      @values.extend(TokensStringRepresentation)

      set_start_and_end_indexes values
      set_time_and_interval values
    end

    def set_start_and_end_indexes(values)
      @start_index = values.first.start_index
      @end_index = values.last.end_index
    end

    def set_time_and_interval(values)
      first_time = values[1]
      second_time = values[3]

      first_time_minutes = first_time.hours * 60 + first_time.minutes
      second_time_minutes = second_time.hours * 60 + second_time.minutes

      raise "Second time in interval is less than the first one" if first_time_minutes > second_time_minutes

      @hours = first_time.hours
      @minutes = first_time.minutes
      @interval = second_time_minutes - first_time_minutes
    end

    def to_s
      "{ending_form}"
    end
  end
end