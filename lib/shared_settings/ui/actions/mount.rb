module SharedSettings
  module UI
    module Actions
      class Mount < SharedSettings::UI::Action
        def self.route_regex
          %r{\A/\Z}
        end

        def get
          [200, headers, [html_body]]
        end

        private

        def headers
          { 'Content-Type' => 'text/html' }
        end

        def html_body
          <<-HTML_BODY
              <!DOCTYPE html>
              <html lang="en">
                <head>
                  <meta charset="utf-8">
                  <meta http-equiv="X-UA-Compatible" content="IE=edge">
                  <meta name="viewport" content="width=device-width,initial-scale=1">
                  <title>shared-settings-ui</title>
                  <link href="assets/app.css" rel=stylesheet>
                  <script>
                    window.sharedSettingsApiBase = "#{@request.script_name}"
                  </script>
                </head>
                <body>
                  <div id=app></div>
                  <script src="assets/app.js"></script>
                  <script src="assets/chunks.js"></script>
                </body>
              </html>
          HTML_BODY
        end
      end
    end
  end
end
