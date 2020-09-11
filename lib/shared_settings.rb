require 'forwardable'

require 'shared_settings/version'
require 'shared_settings/setting'
require 'shared_settings/instance'
require 'shared_settings/configuration'
require 'shared_settings/persistence/redis'
require 'shared_settings/serialized_setting'

module SharedSettings
  class SettingNotFoundError < StandardError; end

  extend self
  extend Forwardable

  def new(storage_adapter)
    SharedSettings::Instance.new(storage_adapter)
  end

  def configure
    yield configuration if block_given?
  end

  def instance
    configuration.default
  end

  def exists?(name)
    get(name)

    true
  rescue SettingNotFoundError
    false
  end

  def_delegators :instance,
    :put,
    :get,
    :all,
    :delete

  private

  def configuration
    @configuration ||= SharedSettings::Configuration.new
  end

  def configuration=(configuration)
    @configuration = configuration
  end
end
