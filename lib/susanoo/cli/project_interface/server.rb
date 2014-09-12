module Susanoo::CLI
  module Commands
    # Provide the `server` command for project wide usage.
    module Server
      extend ::ActiveSupport::Concern

      included do
        map 's' => :server

        method_option :debug, default: true
        method_option :built, default: false
        method_option :port, default: 3000
        desc 'server [PLATFROM]', 'Run development server. Simulate the given PLATFORM'
        def server(platform = 'android')
          port = options[:port]

          if options[:built]
            return not_built unless built?
            app = static_server_for platform

          else
            require File.join(project_root, 'config/routes')
            # Set global debug flag
            Susanoo::Project.debug = options[:debug]
            app = ROUTER

          end
          # Run the selected application to serve the project
          Rack::Server.start(app: app, server: :thin, Port: port,
                             debug: options[:debug])
        end
      end

      private

      # Does project is built?
      def built?
        return false unless File.directory? File.join(project_root, 'www')
        true
      end

      def not_built
        error "'www' directory is not present. Build you app first."
      end

      # Return a `Rack` applciation which will serve the
      # already built project under specific platform path
      def static_server_for(platform)
        require 'rack/rewrite'

        root = project_root

        app = Rack::Builder.new do
          use Rack::Rewrite do
            rewrite   '/',  "/#{platform}_asset/www"
          end

          map "/#{platform}_asset/www/" do
            run Rack::Directory.new File.join(root, 'www')
          end
        end

      end
    end
  end
end
