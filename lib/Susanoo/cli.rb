require 'thor'
require 'Susanoo/generators'


module Susanoo
  class Cli < Thor
    desc "new PROJECT", "Create a new Susanoo/Cordova project"
    def new(name)
      Susanoo::Project.folder_name = name
      Susanoo::Generators::Cordova.start

      Susanoo::Generators::Frameworks.start
    end

    method_option :aliases => "g"
    desc "generate GENERATOR [options]", "Run the given generator"
    def generate(generator=nil, *options)
      if generator.nil?
        print_generator_list
        return
      end

      begin
        generator = Susanoo::Generators.const_get(camelize(generator.downcase))
      rescue NameError
        print  "[Error]:".colorize(:red)
        say  "Generator `#{generator}` not found."
        exit 1
      end
      generator.invoke(*options)
    end

    desc "server", "Run development server."
    def server(port=6000)
      require 'sprockets'
      require 'rack'
      requireh 'rack/rewrite'

      root = Dir.getwd
      #Rack::Handler::WEBrick.run :Port => 3000, :DocumentRoot => root
      server = Rack::Builder.app do
        map "/statics" do
          project_root = Dir.getwd

          assets = Sprockets::Environment.new(project_root) do |env|
            env.logger = Logger.new(STDOUT)
          end

          assets.append_path(File.join(project_root, 'www', 'assets'))
          assets.append_path(File.join(project_root, 'www', 'assets', 'javascripts'))
          assets.append_path(File.join(project_root, 'www', 'assets', 'stylesheets'))
          assets.append_path(File.join(project_root, 'www', 'assets', 'images'))

          run assets
        end

        map "/" do
          use Rack::Static, :urls => [""], :index => "index.html"
          run lambda { |env|
            [
             200,
             {
               'Content-Type'  => 'text/html',
               'Cache-Control' => 'public, max-age=86400'
             },
             File.open('www/index.html', File::RDONLY)
            ]
          }
        end
      end
      Rack::Handler::WEBrick.run(server, Port: port)
    end

    private

    def camelize(str)
      str.split("_").each {|s| s.capitalize! }.join("")
    end

    def print_generator_list
      say "Available generators:"
      say "---------------------------------------------------"
      Susanoo::Generators.constants.each do |g|
        generator = Susanoo::Generators.const_get(g)
        generator_name = generator.to_s.downcase.split("::").last
        say "\t #{generator_name}\t\t #{generator.desc}\n"
      end
    end
  end
end
