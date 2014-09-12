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
