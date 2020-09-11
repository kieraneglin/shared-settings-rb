require 'shared_settings/version'
require 'shared_settings/setting'
require 'shared_settings/serialized_setting'

require 'shared_settings/persistence/redis'

module SharedSettings
  class SettingNotFoundError < StandardError; end
end
