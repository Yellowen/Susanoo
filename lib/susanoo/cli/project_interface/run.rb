module Susanoo::CLI
  module Commands
    # Provide the `run` command for project wide usage.
    module Run
      extend ::ActiveSupport::Concern

      included do

        map 'r' => :run_in

        desc 'run PLATFORM', 'Run application on PLATFORM.'
        method_option :release, default: false
        def run_in(platform = :android)
          debug_flag = '--debug'
          debug_flag = '--release' if options[:release]

          Susanoo::Project.debug = false
          Susanoo::Project.debug = true if debug_flag == '--debug'

          # Build the project first
          build

          inside Susanoo::Project.path do
            debug_flag = '--debug'
            debug_flag = '--release' if options[:release]

            system "cordova run #{platform.to_s} #{debug_flag}"
          end
        end

      end
    end
  end
end
