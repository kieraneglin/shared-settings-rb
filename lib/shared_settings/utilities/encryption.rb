require 'openssl'
require 'securerandom'

module SharedSettings
  module Utilities
    class Encryption
      INIT_VEC_SIZE = 16
      AES_BLOCK_SIZE = 16
      ENCRYPTION_KEY_SIZE = 32

      ENCRYPTION_ALGORITHM = 'AES-256-CBC'.freeze

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

      def decrypt(init_vec, cipher_text)
        cipher_data = Base16.string_to_bytes(cipher_text)
        cipher_instance = decryption_cipher(init_vec)

        cipher_instance.update(cipher_data) + cipher_instance.final
      end

      private

      def encryption_cipher(init_vec)
        build_cipher(OpenSSL::Cipher.new(ENCRYPTION_ALGORITHM).encrypt, init_vec)
      end

      def decryption_cipher(init_vec)
        build_cipher(OpenSSL::Cipher.new(ENCRYPTION_ALGORITHM).decrypt, init_vec)
      end

      def build_cipher(cipher, init_vec)
        cipher.iv = Base16.string_to_bytes(init_vec)
        cipher.key = Base16.string_to_bytes(@key)
        cipher.padding = AES_BLOCK_SIZE

        cipher
      end
    end
  end
end
