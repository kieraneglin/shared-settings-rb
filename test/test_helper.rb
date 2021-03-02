$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'shared_settings'
require_relative 'support/mock_adapter'

require 'minitest/autorun'
