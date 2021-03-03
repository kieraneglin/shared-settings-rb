require 'json'

module SharedSettings
  module UI
    module Actions
      class Setting < SharedSettings::UI::Action
        def self.route_regex
          %r{\A/api/settings(/(?<setting_name>\w*))?(/destroy)?\Z}
        end

        def get
          all_settings_as_json = JSON.dump(SharedSettings.all.map(&:to_h))

          [200, headers, [all_settings_as_json]]
        end

        def post
          create_or_update_setting(
            @params['name'],
            @params['type'],
            @params['value'],
            @params['encrypted']
          )

          [201, headers, ['']]
        end

        def put
          create_or_update_setting(
            @params['setting_name'],
            @params['type'],
            @params['value'],
            @params['encrypted']
          )

          [201, headers, ['']]
        end

        def delete
          SharedSettings.delete(@params['setting_name'])

          [200, headers, ['']]
        end

        private

        def create_or_update_setting(name, type, value, encrypted)
          SharedSettings.put(
            name,
            SharedSettings::Setting.deserialize_value(value, type),
            encrypt: !!encrypted
          )
        end
      end
    end
  end
end
