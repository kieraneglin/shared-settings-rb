module SharedSettings
  class SerializedSetting
    #  All data values are represented by strings (similar to Redis).
    #  This means that, regardless of what adaptor is being implemented,
    #  all adaptors must accept and return data in the format which we will outline.
    #
    #  Storage adaptors are only responsible for storing the setting as-given and returning
    #  it in the expected format. Here is a list of formats and their string representation:
    #
    #  number: "1234"
    #  string: "any string"
    #  boolean: "1" or "0"
    #  range: "low,high". eg: "1,5" *inclusive*

    attr_reader :name, :type, :value

    def initialize(name, raw_value)
      @name = name.to_s
      @type = determine_type(raw_value)
      @value = serialize_raw_value(raw_value)
    end

    private

    def determine_type(raw_value)
      case raw_value
      when Numeric
        'number'
      when String
        'string'
      when TrueClass, FalseClass
        'boolean'
      when Range
        'range'
      else
        raise ArgumentError, "`#{raw_value}` must be a number, string, boolean, or range"
      end
    end

    def serialize_raw_value(raw_value)
      case type
      when 'string'
        raw_value
      when 'number'
        raw_value.to_s
      when 'boolean'
        raw_value ? '1' : '0'
      when 'range'
        determine_range_bounds(raw_value)
      end
    end

    def determine_range_bounds(raw_value)
      head, tail = raw_value.to_a.values_at(0, -1)

      if !head.is_a?(Numeric) || !tail.is_a?(Numeric)
        raise ArgumentError, 'Only ascending purely numeric ranges are accepted'
      end

      [head, tail].join(',')
    end
  end
end
