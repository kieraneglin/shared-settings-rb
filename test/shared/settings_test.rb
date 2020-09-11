require "test_helper"

class SharedSettingsTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::SharedSettings::VERSION
  end
end
