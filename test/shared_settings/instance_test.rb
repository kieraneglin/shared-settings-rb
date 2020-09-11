require 'test_helper'

module SharedSettings
  class InstanceTest < Minitest::Test
    def setup
      @client = ::Redis.new
      @adapter = SharedSettings::Persistence::Redis.new(@client)
      @instance = SharedSettings::Instance.new(@adapter)
    end

    def teardown
      keys = @client.keys("#{SharedSettings::Persistence::Redis::PREFIX}:*")

      @client.del(*keys) if keys.any?
    end

    def test_get_returns_value_directly
      @instance.put('a', 1)

      assert_equal 1, @instance.get('a')
    end
  end
end
