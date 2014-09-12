require 'thor'
require 'susanoo/generators'
require 'susanoo/irb'

require_relative './project_interface/commands'

module Susanoo
  module CLI
    # Project wide `Thor` class which is responsible for
    # each command that user execute inside project
    class ProjectInterface < Thor

      # Include the Thor actions
      include ::Thor::Actions

      package_name 'Susanoo'

      map 'r' => :run_in
      map 'b' => :build
      map 'c' => :console

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

      desc 'run PLATFORM', 'Run application on PLATFORM.'
      def run_in(platform = :android)
        # Build the project first
        build

        inside Susanoo::Project.path do
          system "cordova run #{platform.to_s}"
        end
      end

      desc 'console', 'Run pry in environment of `Susanoo`. '
      def console
        project_root = Susanoo::Project.path
        require File.join(project_root, 'config/routes')

        IRB.start_session(binding)
      end

      private
      # Private ---------------------------

      def print_generator_list
        say 'Available generators:'
        say '---------------------------------------------------'
        Susanoo::Generators.constants.each do |g|
          generator = Susanoo::Generators.const_get(g)

          if generator.respond_to?(:global_generator?) && \
            !generator.global_generator?
            generator_name = generator.to_s.split('::').last.underscore
            say "#{generator_name}\t\t #{generator.desc}\n"
          end

        end

      end

      def project_root
        Susanoo::Project.path
      end
    end
  end
end
