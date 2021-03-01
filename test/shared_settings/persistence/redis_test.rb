require 'test_helper'
require 'redis'

module SharedSettings
  module Persistence
    class RedisTest < Minitest::Test
      def setup
        SharedSettings.configure do |config|
          config.encryption_key = ENV['SHARED_SETTINGS_KEY']
        end

        @client = ::Redis.new
        @adapter = SharedSettings::Persistence::Redis.new(@client)
      end

      def teardown
        keys = @client.keys("#{SharedSettings::Persistence::Redis::PREFIX}:*")

        @client.del(*keys) if keys.any?
      end

      def test_setting_stored_and_fetched
        values = [
          ['a', 123],
          ['b', 12.3],
          ['c', -123],
          ['d', ''],
          ['e', true],
          ['f', false],
          ['g', 1..4]
        ]

        values.each do |name, value|
          setting = SharedSettings::SerializedSetting.new(name, value)
          returned_name = @adapter.put(setting)

          assert_equal value, SharedSettings::Instance.new(@adapter).get(returned_name)
        end
      end

      def test_previous_settings_overwritten
        @adapter.put(SharedSettings::SerializedSetting.new('a', 1))
        @adapter.put(SharedSettings::SerializedSetting.new('a', false))

        assert_equal false, SharedSettings::Instance.new(@adapter).get('a')
      end

      def test_encrypted_settings_stored_and_fetched
        setting = SharedSettings::SerializedSetting.new('a', 1, encrypt: true)
        returned_name = @adapter.put(setting)

        fetched_setting_data = @adapter.get(returned_name)

        assert fetched_setting_data.encrypted
      end

      def test_get_returns_error_if_not_found
        assert_raises SettingNotFoundError do
          @adapter.get('not-real')
        end
      end

      def test_all_keys_returns_all_settings
        @adapter.put(SharedSettings::SerializedSetting.new('a', 1))
        @adapter.put(SharedSettings::SerializedSetting.new('b', true))
        @adapter.put(SharedSettings::SerializedSetting.new('c', 'asdf'))

        fetched_settings = @adapter.all_keys

        assert_equal 3, fetched_settings.length
        assert fetched_settings.include?('a')
        assert fetched_settings.include?('b')
        assert fetched_settings.include?('c')
      end

      def test_redis_deletion
        name = 'doomed-setting'
        @adapter.put(SharedSettings::SerializedSetting.new(name, 1))

        assert @adapter.get(name)
        assert_equal true, @adapter.delete(name)

        assert_raises SettingNotFoundError do
          @adapter.get(name)
        end
      end
    end
  end
end
