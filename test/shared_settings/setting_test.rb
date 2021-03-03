require 'test_helper'

module SharedSettings
  class SettingTest < Minitest::Test
    def setup
      SharedSettings.configure do |config|
        config.encryption_key = ENV['SHARED_SETTINGS_KEY']
      end
    end

    def test_self_deserialize_value
      assert_equal 123, SharedSettings::Setting.deserialize_value('123', 'number')
      assert_equal(-123, SharedSettings::Setting.deserialize_value('-123', 'number'))
      assert_equal 12.3, SharedSettings::Setting.deserialize_value('12.3', 'number')

      assert_equal '', SharedSettings::Setting.deserialize_value('', 'string')
      assert_equal 'asd', SharedSettings::Setting.deserialize_value('asd', 'string')

      assert_equal true, SharedSettings::Setting.deserialize_value('1', 'boolean')
      assert_equal false, SharedSettings::Setting.deserialize_value('0', 'boolean')

      assert_equal 1..3, SharedSettings::Setting.deserialize_value('1,3', 'range')
      assert_equal(-1..4, SharedSettings::Setting.deserialize_value('-1,4', 'range'))
    end

    def test_name_and_type_become_symbols
      assert_equal :a, setting('a', 'number', '1', false).name
      assert_equal :number, setting('a', 'number', '1', false).type
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

    def test_to_h
      setting = setting('a', 'number', '1', false)

      setting_hash = setting.to_h

      assert setting_hash[:name] == setting.name
      assert setting_hash[:value] == setting.value
      assert setting_hash[:type] == setting.type
      assert setting_hash[:encrypted] == setting.encrypted
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
