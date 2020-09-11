require 'test_helper'
require 'redis'

module SharedSettings
  module Persistence
    class RedisTest < Minitest::Test
      def setup
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
          returned_name = @adapter.put(name, value)

          assert_equal value, @adapter.get(returned_name).value
        end
      end

      def test_previous_settings_overwritten
        @adapter.put('a', 1)
        @adapter.put('a', false)

        assert_equal false, @adapter.get('a').value
      end

      def test_get_returns_error_if_not_found
        assert_raises SettingNotFoundError do
          @adapter.get('not-real')
        end
      end

      def test_all_returns_all_settings
        @adapter.put('a', 1)
        @adapter.put('b', true)
        @adapter.put('c', 'asdf')

        fetched_settings = @adapter.all

        assert_equal 3, fetched_settings.length
        assert_equal 1, fetched_settings.find { |s| s.name == :a }.value
        assert_equal true, fetched_settings.find { |s| s.name == :b }.value
        assert_equal 'asdf', fetched_settings.find { |s| s.name == :c }.value
      end

      def test_redis_deletion
        name = 'doomed-setting'
        @adapter.put(name, 1)

        assert @adapter.get(name)
        assert_equal true, @adapter.delete(name)

        assert_raises SettingNotFoundError do
          @adapter.get(name)
        end
      end
    end
  end
end
