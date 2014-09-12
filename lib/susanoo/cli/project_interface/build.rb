module Susanoo::CLI
  module Commands
    # Provide the `generate` & `destroy` commands for project wide usage.
    module Build
      extend ::ActiveSupport::Concern

      included do
        desc 'build [PLATFORM]', 'Build the application for given PLATFORM (default=android).'
        def build(platform = 'android')

          require File.join(project_root, 'config/routes')
          router = ROUTER.instance_variable_get('@router')

          build_dir = File.join(project_root, 'www')
          # setup build directory

          remove_file build_dir if File.exist? build_dir
          # Create the www directory if there isn't
          # WWW directory will be the build directory
          # which will contains the static files.
          #
          # NOTE: cordova only uses this directory
          # and we can't change it as far as I know
          empty_directory build_dir

          router.routes.each do |route|
            controller = route.dest
            if controller.respond_to? :build
              say_status 'build', "Controller: #{controller.__getobj__.class}"

              # options to pass to controller build method
              options = {
                route: route.dup,
                platform: platform
              }

              controller.build(self, options)
            else
              say_status 'warning', "#{controller.__getobj__.class.to_s}' does not have 'build' method.",
              :yellow
            end
          end
        end
      end
    end
  end
end
