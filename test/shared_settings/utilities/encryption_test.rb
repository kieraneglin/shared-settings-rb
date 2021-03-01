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

        iv, data = instance.encrypt("test")

        # Not a great test but it shows that output != the input at the very least
        # The round-trip decryption tests will be more valuable
        assert iv.length > 8
        assert data.length > 8
        assert iv != data
      end
    end
  end
end
