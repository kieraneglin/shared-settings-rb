module SharedSettings
  class Setting
    attr_reader :name, :type, :value, :encrypted

    def self.deserialize_value(value, type)
      case type.to_sym
      when :string
        value
      when :number
        value.include?('.') ? value.to_f : value.to_i
      when :boolean
        value == '1'
      when :range
        # Ranges will _always_ become two-dot ranges
        lower, upper = value.split(',').map(&:to_i)

        lower..upper
      else
        raise ArgumentError, "Unable to deserialize `#{type}` type"
      end
    end

    def initialize(name, type, serialized_value, encrypted)
      @name = name.to_sym
      @type = type.to_sym
      @encrypted = encrypted

      if encrypted
        decrypted_value = decrypt_value(serialized_value)
        @value = self.class.deserialize_value(decrypted_value, type)
      else
        @value = self.class.deserialize_value(serialized_value, type)
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
