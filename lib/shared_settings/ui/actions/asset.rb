module SharedSettings
  module UI
    module Actions
      class Asset < SharedSettings::UI::Action
        def self.route_regex
          %r{\A/assets/.*}
        end

        def get
          Rack::Files.new(SharedSettings::UI.asset_root).call(@request.env)
        end
      end
    end
  end
end
