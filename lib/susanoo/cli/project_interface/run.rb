module Susanoo::CLI
  module Commands
    # Provide the `run` command for project wide usage.
    module Run
      extend ::ActiveSupport::Concern

      included do

        map 'r' => :run_in

        desc 'run PLATFORM', 'Run application on PLATFORM.'
        def run_in(platform = :android)
          # Build the project first
          build
          inside Susanoo::Project.path do
            system "cordova run #{platform.to_s}"
          end
        end

      end
    end
  end
end
