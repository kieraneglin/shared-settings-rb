require 'openssl'
require 'securerandom'

module SharedSettings
  module Utilities
    class Encryption
      INIT_VEC_SIZE = 16
      AES_BLOCK_SIZE = 16
      ENCRYPTION_KEY_SIZE = 32

      def self.generate_aes_key(size = ENCRYPTION_KEY_SIZE)
        # .upcase is to match the Elixir implementation
        SecureRandom.hex(size).upcase
      end

      def initialize(key)
        @key = key
      end

      def encrypt(clear_text)
        init_vec = Encryption.generate_aes_key(INIT_VEC_SIZE)
        cipher_instance = encryption_cipher(init_vec)
        encrypted_data = cipher_instance.update(clear_text) + cipher_instance.final

        [init_vec, Base16.bytes_to_string(encrypted_data)]
      end

      private

      def encryption_cipher(init_vec)
        cipher_instance = OpenSSL::Cipher.new('AES-256-CBC')
        cipher_instance.encrypt
        # Note: these _must_ be after the .encrypt call or generated cipher data won't be valid
        cipher_instance.iv = Base16.string_to_bytes(init_vec)
        cipher_instance.key = Base16.string_to_bytes(@key)
        cipher_instance.padding = AES_BLOCK_SIZE

        cipher_instance
      end
    end
  end
end
