require 'test_helper'

module SharedSettings
  class SerializedSettingTest < Minitest::Test
    def setup
      SharedSettings.configure do |config|
        config.encryption_key = ENV['SHARED_SETTINGS_KEY']
      end
    end

    def test_types_are_assigned
      assert_equal 'number', serialized_setting(:a, 1).type
      assert_equal 'number', serialized_setting(:a, 1.2).type
      assert_equal 'number', serialized_setting(:a, -1).type

      assert_equal 'string', serialized_setting(:b, '').type
      assert_equal 'string', serialized_setting(:b, 'asd').type

      assert_equal 'boolean', serialized_setting(:c, true).type
      assert_equal 'boolean', serialized_setting(:c, false).type

      assert_equal 'range', serialized_setting(:d, 1..4).type
      assert_equal 'range', serialized_setting(:d, 1...4).type
      assert_equal 'range', serialized_setting(:d, -1...4).type
    end

    def test_unsupported_types_raise_error
      assert_raises ArgumentError do
        serialized_setting(:a, nil)
      end

      assert_raises ArgumentError do
        serialized_setting(:a, { b: 2 })
      end
    end

    def test_value_is_serialized
      assert_equal '1', serialized_setting(:a, 1).value
      assert_equal '1.2', serialized_setting(:a, 1.2).value
      assert_equal '-1', serialized_setting(:a, -1).value

      assert_equal '', serialized_setting(:b, '').value
      assert_equal 'asd', serialized_setting(:b, 'asd').value

      assert_equal '1', serialized_setting(:c, true).value
      assert_equal '0', serialized_setting(:c, false).value

      assert_equal '1,4', serialized_setting(:d, 1..4).value
      assert_equal '1,3', serialized_setting(:d, 1...4).value
      assert_equal '-1,3', serialized_setting(:d, -1...4).value
    end

    def test_only_ascending_numeric_ranges_accepted
      assert_raises ArgumentError do
        serialized_setting(:a, 'a'..'z')
      end

      assert_raises ArgumentError do
        serialized_setting(:a, 5..0)
      end
    end

    def test_encrypting_settings
      setting = serialized_setting(:a, 1, encrypt: true)

      assert setting.encrypted
      assert setting.value.include?('|')
    end

    private

    def serialized_setting(name, value, encrypt: false)
      SharedSettings::SerializedSetting.new(name, value, encrypt: encrypt)
    end
  end
end
