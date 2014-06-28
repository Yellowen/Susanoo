require 'thor'
require 'susanoo/generators'


module Susanoo
  module CLI
    class Project < Thor

      include ::Thor::Actions

      package_name 'Susanoo'

      map 's' => :server
      map 'g' => :generate

      def self.root=(path)
        @@root = path
        Susanoo::Project.path = path
      end

      desc 'generate GENERATOR [options]', 'Run the given generator'
      def generate(generator_name = nil, *options)
        if generator_name.nil?
          print_generator_list
          return
        end

        begin
          generator = Susanoo::Generators.const_get(camelize(generator_name.downcase))
        rescue NameError
          print  '[Error]:'.colorize(:red)
          say  "Generator `#{generator}` not found."
          exit 1
        end
        generator.start options
      end

      method_option :debug, default: true
      desc 'server', 'Run development server.'
      def server(port = 3000)
        project_root = Susanoo::Project.path
        require File.join(project_root, 'config/routes')

        # Set global debug flag
        Susanoo::Project.debug = options[:debug]

        app = Rack::Server.start(app: ROUTER, server: :thin, Port: port,
                                 debug: options[:debug])
      end

      desc 'build', 'Build the application.'
      def build
        project_root = Susanoo::Project.path

        require File.join(project_root, 'config/routes')

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

        Susanoo::StaticGenerator.classes.each do |klass|
          instance = klass.new
          if instance.respond_to? :build
            instance.build(self)
          else
            puts "[Warning]: '#{instance.class.to_s}' does not have 'build' method."
          end
        end

      end

      private
      # Private ---------------------------

      def camelize(str)
        str.split("_").each {|s| s.capitalize! }.join("")
      end

      def underscore(str)
        str.gsub(/::/, '/').
          gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
          gsub(/([a-z\d])([A-Z])/,'\1_\2').
          tr("-", "_").
          downcase
      end

      def print_generator_list
        say "Available generators:"
        say "---------------------------------------------------"
        Susanoo::Generators.constants.each do |g|
          generator = Susanoo::Generators.const_get(g)

          unless generator.is_global_generator?
            generator_name = underscore(generator.to_s.split("::").last)
            say "#{generator_name}\t\t #{generator.desc}\n"
          end

        end

      end
    end
  end
end
