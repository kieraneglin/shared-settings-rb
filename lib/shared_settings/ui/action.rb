module SharedSettings
  module UI
    class Action
      def initialize(request)
        route_params = self.class.route_regex.match(request.path_info).named_captures
        request_body = request.env['rack.input'].gets
        body_params = request_body ? JSON.parse(request_body) : {}

        @request = request
        @params = route_params.merge(body_params)
      end

      private

      def headers
        { 'Content-Type' => 'application/json' }
      end
    end
  end
end
