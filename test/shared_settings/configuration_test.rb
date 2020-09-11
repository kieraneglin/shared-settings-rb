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
  end
end
