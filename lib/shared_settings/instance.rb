require 'forwardable'

module SharedSettings
  class Instance
    extend Forwardable
    attr_reader :storage_adapter

    def initialize(storage_adapter)
      @storage_adapter = storage_adapter
    end

    def get(name)
      storage_adapter.get(name).value
    end

    def_delegators :storage_adapter,
      :put,
      :all,
      :delete
  end
end
