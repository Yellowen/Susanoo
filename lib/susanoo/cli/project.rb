require 'thor'
require 'susanoo/generators'


module Susanoo
  module CLI
    class Project < Thor

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

      method_option :debug, default: false
      desc 'server', 'Run development server.'
      def server(port = 3000)
        project_root = Susanoo::Project.path
        require File.join(project_root, 'config/routes')

        #app = Susanoo::Application.new(project_root, port,
        #                               options[:debug])

        app = Rack::Server.start(app: ROUTER, server: :thin, Port: port,
                                 debug: options[:debug])

      end

      private

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
