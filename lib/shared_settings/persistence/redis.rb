module SharedSettings
  module Persistence
    class Redis
      PREFIX = 'shared_settings'.freeze

      def initialize(client)
        @client = client
      end

      def put(name, value)
        serialized_setting = SharedSettings::SerializedSetting.new(name, value)

        @client.hset(prefixed_name(serialized_setting.name), {
          'name' => serialized_setting.name,
          'type' => serialized_setting.type,
          'value' => serialized_setting.value
        })

        serialized_setting.name
      end

      def get(name)
        stored_value = @client.hgetall(prefixed_name(name))

        if stored_value.keys.any?
          return SharedSettings::Setting.new(
            stored_value['name'],
            stored_value['type'],
            stored_value['value']
          )
        end

        raise SettingNotFoundError
      end

      private

      def prefixed_name(name)
        "#{PREFIX}:#{name}"
      end
    end
  end
end
