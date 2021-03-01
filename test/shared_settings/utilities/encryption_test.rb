require 'test_helper'

module SharedSettings
  module Utilities
    class EncryptionTest < Minitest::Test
      SUBJECT = SharedSettings::Utilities::Encryption

      def setup
        SharedSettings.configure do |config|
          config.encryption_key = ENV['SHARED_SETTINGS_KEY']
        end
      end

      def test_aes_key_generated
        key_one = SUBJECT.generate_aes_key
        key_two = SUBJECT.generate_aes_key

        assert key_one != key_two
        assert_equal 64, key_one.length
      end

      def test_custom_key_size_can_be_passed
        # 16 because the size we pass is for raw bytes with result in n*2 hex chars
        assert_equal 16, SUBJECT.generate_aes_key(8).length
      end

      def test_encryption_returns_iv_and_data
        key = SharedSettings.configuration.encryption_key
        instance = SUBJECT.new(key)

        iv, data = instance.encrypt('test')

        # Not a great test but it shows that output != the input at the very least
        # The round-trip decryption tests will be more valuable
        assert iv.length > 8
        assert data.length > 8
        assert iv != data
      end

      def test_decryption_produces_valid_results
        key = SharedSettings.configuration.encryption_key
        instance = SUBJECT.new(key)
        iv, cipher_text = instance.encrypt('test')

        plaintext = instance.decrypt(iv, cipher_text)

        assert_equal 'test', plaintext
        assert iv != plaintext
        assert cipher_text != plaintext
      end

      def test_decryption_from_elixir
        key = SharedSettings.configuration.encryption_key
        instance = SUBJECT.new(key)
        # These values are generated by the Elixir package
        # TODO: these tests would be more useful by writing to Redis from Elixir
        # and reading that data from Ruby.  Need to Dockerize, etc.
        iv = '0020E2D24C3DBE099C011CB1081A5999'
        cipher_text = 'AB0CB34AA20A15531F69FE08C6294438'

        plaintext = instance.decrypt(iv, cipher_text)

        assert_equal 'from elixir', plaintext
      end
    end
  end
end
