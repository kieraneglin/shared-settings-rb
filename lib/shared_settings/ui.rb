require 'rack'
require 'shared-settings'

require 'shared_settings/ui/middleware'

module SharedSettings
  module UI
    def self.asset_root
      Pathname(__FILE__).dirname.expand_path.join('ui')
    end

    def self.app
      app = ->(_) { [200, { 'Content-Type' => 'text/html' }, ['']] }
      builder = Rack::Builder.new

      yield builder if block_given?
      builder.use(SharedSettings::UI::Middleware)
      builder.run(app)

      builder
    end
  end
end
