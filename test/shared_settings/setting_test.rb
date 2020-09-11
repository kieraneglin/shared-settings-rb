require 'test_helper'

module SharedSettings
  class SettingTest < Minitest::Test
    def test_name_and_type_become_symbols
      assert_equal :a, setting('a', 'number', '1').name
      assert_equal :number, setting('a', 'number', '1').type
    end

    def test_values_are_deserialized
      assert_equal 123, setting('a', 'number', '123').value
      assert_equal(-123, setting('a', 'number', '-123').value)
      assert_equal 12.3, setting('a', 'number', '12.3').value

      assert_equal '', setting('b', 'string', '').value
      assert_equal 'asd', setting('b', 'string', 'asd').value

      assert_equal true, setting('c', 'boolean', '1').value
      assert_equal false, setting('c', 'boolean', '0').value

      assert_equal 1..3, setting('d', 'range', '1,3').value
      assert_equal (-1..4), setting('d', 'range', '-1,4').value
    end

    def test_unsupported_types_raise_error
      assert_raises ArgumentError do
        setting('a', 'unknown', '')
      end
    end

    private

    def setting(name, type, value)
      SharedSettings::Setting.new(name, type, value)
    end
  end
end
