require "test_helper"

class SharedSettings::SerializedSettingTest < Minitest::Test
  def test_types_are_assigned
    assert_equal 'number', setting(:a, 1).type
    assert_equal 'number', setting(:a, 1.2).type
    assert_equal 'number', setting(:a, -1).type

    assert_equal 'string', setting(:b, '').type
    assert_equal 'string', setting(:b, 'asd').type

    assert_equal 'boolean', setting(:c, true).type
    assert_equal 'boolean', setting(:c, false).type

    assert_equal 'range', setting(:d, 1..4).type
    assert_equal 'range', setting(:d, 1...4).type
    assert_equal 'range', setting(:d, -1...4).type
  end

  def test_unsupported_types_raise_error
    assert_raises ArgumentError do 
      setting(:a, nil)
    end

    assert_raises ArgumentError do 
      setting(:a, { b: 2 })
    end
  end

  def test_value_is_serialized
    assert_equal '1', setting(:a, 1).value
    assert_equal '1.2', setting(:a, 1.2).value
    assert_equal '-1', setting(:a, -1).value

    assert_equal '', setting(:b, '').value
    assert_equal 'asd', setting(:b, 'asd').value

    assert_equal '1', setting(:c, true).value
    assert_equal '0', setting(:c, false).value

    assert_equal '1,4', setting(:d, 1..4).value
    assert_equal '1,3', setting(:d, 1...4).value
    assert_equal '-1,3', setting(:d, -1...4).value
  end

  def test_only_ascending_numeric_ranges_accepted
    assert_raises ArgumentError do 
      setting(:a, 'a'..'z')
    end

    assert_raises ArgumentError do 
      setting(:a, 5..0)
    end
  end

  private

  def setting(name, value)
    SharedSettings::SerializedSetting.new(name, value)
  end
end
