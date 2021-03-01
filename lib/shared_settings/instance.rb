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

    def all
      storage_adapter.all_keys.map do |key|
        get(key)
      end
    end

    def_delegators :storage_adapter, :delete
  end
end
