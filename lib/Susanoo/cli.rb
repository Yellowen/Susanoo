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

    desc "server", "Run development server."
    def server(port=6000)
      require 'sprockets'
      require 'rack'
      require 'rack/rewrite'

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
      puts ">>>>>>>   >>>>>>>>>>", server

      Rack::Handler::Thin.run(server, Port: port)
      #server.start
    end
  end
end
