$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'shared-settings'
require 'shared-settings-ui'
require_relative 'support/mock_adapter'

require 'minitest/autorun'
