require 'test_helper'

module SharedSettings
  class ConfigurationTest < Minitest::Test
    def test_raises_if_no_default
      assert_raises ArgumentError do
        SharedSettings::Configuration.new.default
      end
    end

    def test_can_be_set
      config = SharedSettings::Configuration.new

      config.default { :test }

      assert_equal :test, config.default
    end

    def test_encryption_key_can_be_set
      config = SharedSettings::Configuration.new

      config.encryption_key = 'supersecret'

      assert_equal 'supersecret', config.encryption_key
    end
  end
end
