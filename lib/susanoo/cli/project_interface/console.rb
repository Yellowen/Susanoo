require 'susanoo/irb'

module Susanoo::CLI
  module Commands
    # Provide the `console` command for project wide usage.
    module Console
      extend ::ActiveSupport::Concern

      included do

        map 'c' => :console

        desc 'console', 'Run pry in environment of `Susanoo`. '
        def console
          project_root = Susanoo::Project.path
          require File.join(project_root, 'config/routes')

          IRB.start_session(binding)
        end
      end
    end
  end
end
