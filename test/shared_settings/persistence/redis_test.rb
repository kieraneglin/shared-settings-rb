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
          @adapter.put(name, value)

          assert_equal value, @adapter.get(name).value
        end
      end

      def test_get_returns_error_if_not_found
        assert_raises SettingNotFoundError do
          @adapter.get('not-real')
        end
      end
    end
  end
end
