module SharedSettings
  class Setting
    attr_reader :name, :type, :value

    def initialize(name, type, serialized_value)
      @name = name.to_sym
      @type = type.to_sym
      @value = deserialize_value(serialized_value)
    end

    private

    def deserialize_value(serialized_value)
      case type
      when :string
        serialized_value
      when :number
        serialized_value.include?('.') ? serialized_value.to_f : serialized_value.to_i
      when :boolean
        serialized_value == '1'
      when :range
        rebuild_range(serialized_value)
      else
        raise ArgumentError, "Unable to deserialize `#{type}` type"
      end
    end

    # Ranges will _always_ become two-dot ranges
    def rebuild_range(serialized_value)
      lower, upper = serialized_value.split(',').map(&:to_i)

      lower..upper
    end
  end
end
