require 'test_helper'

class SharedSettingsTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil SharedSettings::VERSION
  end

  def test_configure_is_correct_instance
    SharedSettings.configure do |config|
      assert config.is_a?(SharedSettings::Configuration)
    end
  end
end
