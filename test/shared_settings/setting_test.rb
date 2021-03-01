require 'test_helper'

module SharedSettings
  class SettingTest < Minitest::Test
    def setup
      SharedSettings.configure do |config|
        config.encryption_key = ENV['SHARED_SETTINGS_KEY']
      end
    end

    def test_name_and_type_become_symbols
      assert_equal :a, setting('a', 'number', '1', false).name
      assert_equal :number, setting('a', 'number', '1', false).type
    end

    def test_values_are_deserialized
      assert_equal 123, setting('a', 'number', '123', false).value
      assert_equal(-123, setting('a', 'number', '-123', false).value)
      assert_equal 12.3, setting('a', 'number', '12.3', false).value

      assert_equal '', setting('b', 'string', '', false).value
      assert_equal 'asd', setting('b', 'string', 'asd', false).value

      assert_equal true, setting('c', 'boolean', '1', false).value
      assert_equal false, setting('c', 'boolean', '0', false).value

      assert_equal 1..3, setting('d', 'range', '1,3', false).value
      assert_equal (-1..4), setting('d', 'range', '-1,4', false).value
    end

    def test_unsupported_types_raise_error
      assert_raises ArgumentError do
        setting('a', 'unknown', '', false)
      end
    end

    def test_encrypted_settings_decrypted
      enc_setting = serialized_setting(:a, 1, encrypt: true)

      setting = setting(:a, 'number', enc_setting.value, true)

      assert setting.encrypted
      assert_equal 1, setting.value
    end

    private

    def serialized_setting(name, value, encrypt: false)
      SharedSettings::SerializedSetting.new(name, value, encrypt: encrypt)
    end

    def setting(name, type, value, encrypted)
      SharedSettings::Setting.new(name, type, value, encrypted)
    end
  end
end
