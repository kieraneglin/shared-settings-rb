module SharedSettings
  module Utilities
    module Base16
      def self.string_to_bytes(str)
        str.scan(/../).inject('') do |binary, hex_char|
          binary << hex_char.to_i(16).chr
        end
      end

      def self.bytes_to_string(bytestring)
        bytestring.unpack1('H*').upcase
      end
    end
  end
end
