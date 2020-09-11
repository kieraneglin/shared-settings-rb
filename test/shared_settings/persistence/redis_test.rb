require 'test_helper'

module SharedSettings
  module Persistence
    class RedisTest < Minitest::Test
      def test_example
        puts SharedSettings::Persistence::Redis.new
      end
    end
  end
end
