require 'thor'

require_relative './project_interface/commands'

module Susanoo
  module CLI
    # Project wide `Thor` class which is responsible for
    # each command that user execute inside project
    class ProjectInterface < Thor

      # Include the Thor actions
      include ::Thor::Actions

      package_name 'Susanoo'

      # Set the project root
      def self.root=(path)
        @@root = path
        Susanoo::Project.path = path
      end

      # Set source paths for current generator
      def self.source_root
        "#{@@root}/src"
      end

      include Susanoo::CLI::Commands::Server
      include Susanoo::CLI::Commands::Generate
      include Susanoo::CLI::Commands::Build
      include Susanoo::CLI::Commands::Console
      include Susanoo::CLI::Commands::Run


      private

      def project_root
        Susanoo::Project.path
      end
    end
  end
end
