require 'forwardable'

module SharedSettings
  class Instance
    extend Forwardable
    attr_reader :storage_adapter

    def initialize(storage_adapter)
      @storage_adapter = storage_adapter
    end

    def put(name, value, encrypt: false)
      serialized_setting = SharedSettings::SerializedSetting.new(name, value, encrypt: encrypt)

      storage_adapter.put(serialized_setting)
    end

    def get(name)
      storage_adapter.get(name).value
    end

    def_delegators :storage_adapter,
      :all,
      :delete
  end
end
