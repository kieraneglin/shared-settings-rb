# This file uses kebab-case to match the name of the Gem for autoloading purposes

require 'forwardable'

require 'shared_settings/version'
require 'shared_settings/setting'
require 'shared_settings/instance'
require 'shared_settings/configuration'
require 'shared_settings/serialized_setting'

require 'shared_settings/persistence/redis'

require 'shared_settings/utilities/base16'
require 'shared_settings/utilities/encryption'

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

  def configuration
    @configuration ||= SharedSettings::Configuration.new
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

  def configuration=(configuration)
    @configuration = configuration
  end
end
