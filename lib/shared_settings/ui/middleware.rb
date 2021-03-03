require 'shared_settings/ui/action'

require 'shared_settings/ui/actions/mount'
require 'shared_settings/ui/actions/asset'
require 'shared_settings/ui/actions/setting'

module SharedSettings
  module UI
    class Middleware
      def initialize(app)
        @app = app
      end

      def call(env)
        request = Rack::Request.new(env)
        action = find_and_parse_route(request)
        request_method = request.request_method.downcase.to_sym

        return not_found if action.nil? || !action.method_defined?(request_method)

        action.new(request).send(request_method)
      end

      private

      def find_and_parse_route(request)
        routes.find do |action|
          action.route_regex.match?(request.path_info)
        end
      end

      def routes
        [
          Actions::Mount,
          Actions::Asset,
          Actions::Setting
        ]
      end

      def not_found
        [404, { 'Content-Type' => 'application/json' }, ['']]
      end
    end
  end
end
