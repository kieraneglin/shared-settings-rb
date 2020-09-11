module SharedSettings
  class Setting
    attr_reader :name, :type, :value

    def initialize(name, raw_value)
      @name = name
      @raw_value = raw_value

      build_setting!
    end

    private

    def build_setting!
      @type = determine_type
    end

    def determine_type
      case @raw_value
      when Numeric
        'number'
      when String
        'string'
      when TrueClass, FalseClass
        'boolean'
      when Range
        'range'
      else
        raise TypeError.new("`#{@raw_value}` must be a number, string, boolean, or range")
      end
    end
  end
end
