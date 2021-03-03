module SharedSettings
  class Setting
    attr_reader :name, :type, :value, :encrypted

    def initialize(name, type, serialized_value, encrypted)
      @name = name.to_sym
      @type = type.to_sym
      @encrypted = encrypted

      if encrypted
        decrypted_value = decrypt_value(serialized_value)
        @value = deserialize_value(decrypted_value)
      else
        @value = deserialize_value(serialized_value)
      end
    end

    def to_h
      {
        name: name,
        type: type,
        value: value,
        encrypted: encrypted
      }
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

    def decrypt_value(string_value)
      encrypter = SharedSettings::Utilities::Encryption.new(encryption_key)
      iv, cipher_text = string_value.split('|')

      encrypter.decrypt(iv, cipher_text)
    end

    def encryption_key
      SharedSettings.configuration.encryption_key
    end
  end
end
