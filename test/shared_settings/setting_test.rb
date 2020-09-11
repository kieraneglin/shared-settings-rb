require "test_helper"

class SharedSettings::SettingTest < Minitest::Test
  def test_types_are_assigned
    assert_equal 'number', setting(:a, 1).type
    assert_equal 'number', setting(:a, 1.2).type
    assert_equal 'number', setting(:a, -1).type

    assert_equal 'string', setting(:b, '').type
    assert_equal 'string', setting(:b, 'asd').type

    assert_equal 'boolean', setting(:c, true).type
    assert_equal 'boolean', setting(:c, false).type

    assert_equal 'range', setting(:d, 1..2).type
    assert_equal 'range', setting(:d, 1...2).type
  end

  def test_unsupported_types_raise_error
    assert_raises TypeError do 
      setting(:a, nil)
    end

    assert_raises TypeError do 
      setting(:a, { b: 2 })
    end
  end

  private

  def setting(name, value)
    SharedSettings::Setting.new(name, value)
  end
end
