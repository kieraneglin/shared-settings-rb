module SharedSettings
  class MockAdapter
    def put(setting)
      setting
    end

    def get(name)
      SharedSettings::Setting.new(
        name,
        'number',
        '1',
        false
      )
    end

    def all_keys
      ['a']
    end
  end
end
