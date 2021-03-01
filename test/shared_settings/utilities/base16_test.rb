require 'test_helper'

module SharedSettings
  module Utilities
    class Base16Test < Minitest::Test
      SUBJECT = SharedSettings::Utilities::Base16

      def test_encodes_bytes_into_string
        assert_equal 'DEADBEEF', SUBJECT.bytes_to_string("\xDE\xAD\xBE\xEF")
      end

      def test_decodes_string_into_bytes
        assert_equal "\xCA\xFE".force_encoding('BINARY'), SUBJECT.string_to_bytes('CAFE')
      end
    end
  end
end
