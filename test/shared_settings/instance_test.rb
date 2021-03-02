require 'test_helper'

module SharedSettings
  class InstanceTest < Minitest::Test
    def setup
      SharedSettings.configure do |config|
        config.encryption_key = ENV['SHARED_SETTINGS_KEY']
      end

      @client = ::Redis.new
      @adapter = SharedSettings::MockAdapter.new
      @instance = SharedSettings::Instance.new(@adapter)
    end

    def teardown
      # keys = @client.keys("#{SharedSettings::Persistence::Redis::PREFIX}:*")

      # @client.del(*keys) if keys.any?
    end

    def test_put_builds_setting
      mock_value = @instance.put(:test, 123)

      assert mock_value.instance_of?(SharedSettings::SerializedSetting)
    end

    def test_get_returns_hydrated_value
      assert_equal 1, @instance.get('a')
    end
  end
end
