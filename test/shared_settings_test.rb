require 'test_helper'

class SharedSettingsTest < Minitest::Test
  def setup
    @client = ::Redis.new
    @adapter = SharedSettings::Persistence::Redis.new(@client)
  end

  def teardown
    keys = @client.keys("#{SharedSettings::Persistence::Redis::PREFIX}:*")

    @client.del(*keys) if keys.any?
  end

  def test_that_it_has_a_version_number
    refute_nil SharedSettings::VERSION
  end

  def test_configure_is_correct_instance
    SharedSettings.configure do |config|
      assert config.is_a?(SharedSettings::Configuration)
    end
  end

  def test_new_returns_instance_class
    assert SharedSettings.new(@adapter).instance_of?(SharedSettings::Instance)
  end

  def test_delegates_methods
    SharedSettings.configure do |config|
      config.default { SharedSettings.new(@adapter) }
    end

    assert_equal 'test-name', SharedSettings.put('test-name', 1)
    assert_equal 1, SharedSettings.get('test-name')
    assert_equal true, SharedSettings.delete('test-name')
    refute SharedSettings.exists?('test-name')
  end

  def test_exists_returns_expected
    SharedSettings.configure do |config|
      config.default { SharedSettings.new(@adapter) }
    end

    SharedSettings.put('a', 1)

    assert SharedSettings.exists?('a')
    refute SharedSettings.exists?('not-real')
  end
end
