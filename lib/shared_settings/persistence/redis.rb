module SharedSettings
  module Persistence
    class Redis
      PREFIX = 'shared_settings'.freeze

      def initialize(client)
        @client = client
      end

      def put(serialized_setting)
        @client.hset(prefixed_name(serialized_setting.name), {
          'name' => serialized_setting.name,
          'type' => serialized_setting.type,
          'value' => serialized_setting.value,
          'encrypted' => serialized_setting.encrypted ? '1' : '0'
        })

        serialized_setting.name
      end

      def get(name)
        stored_value = @client.hgetall(prefixed_name(name))

        if stored_value.keys.any?
          return SharedSettings::Setting.new(
            stored_value['name'],
            stored_value['type'],
            stored_value['value'],
            stored_value['encrypted'] == '1'
          )
        end

        raise SettingNotFoundError
      end

      def all
        setting_keys = @client.scan_each(match: prefixed_name('*')).to_a

        setting_keys.map do |key|
          setting_name = key.split("#{PREFIX}:").last

          get(setting_name)
        end
      end

      def delete(name)
        @client.del(prefixed_name(name))

        true
      end

      private

      def prefixed_name(name)
        "#{PREFIX}:#{name}"
      end
    end
  end
end
