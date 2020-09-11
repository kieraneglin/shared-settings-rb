require 'shared_settings/version'
require 'shared_settings/setting'
require 'shared_settings/configuration'
require 'shared_settings/serialized_setting'

require 'shared_settings/persistence/redis'

module SharedSettings
  class SettingNotFoundError < StandardError; end

  extend self

  def configure
    yield configuration if block_given?
  end

  private

  def configuration
    @configuration ||= SharedSettings::Configuration.new
  end

  def configuration=(configuration)
    @configuration = configuration
  end
end
