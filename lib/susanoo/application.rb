require 'rack'

class Susanoo::Application
  include SimpleRouter::DSL
  include Sprockets::Helpers

  attr_accessor :environment
  attr_accessor :debug
  attr_reader :template

  def initialize(project_root, port = 3000,
                 deubg = false)
    @debug = debug
    @root = project_root

    @environment = Sprockets::Environment.new(project_root) do |env|
      env.logger = Logger.new(STDOUT)
    end
    @environment.append_path(File.join(project_root, 'www', 'assets'))
    @environment.append_path(File.join(project_root, 'www', 'assets', 'javascripts'))
    @environment.append_path(File.join(project_root, 'www', 'assets', 'stylesheets'))
    @environment.append_path(File.join(project_root, 'www', 'assets', 'images'))
    @environment.append_path(File.join(project_root, 'www', 'assets', 'fonts'))

    @template = Tilt.new(File.join(project_root, 'www/index.html.erb'))

    @port = port
    @@instance = self
  end

  def self.instance
    @@instance
  end

  def debug?
    @debug
  end

  def call(env)
    verb, path  = env['REQUEST_METHOD'], env['PATH_INFO']
    route = self.class.routes.match(verb, path)

    if route.nil?
      [404, {'Content-Type' => 'text/html'}, '404 page not found']
    else
      [200, {'Content-Type' => 'text/html'}, route.action.call(*route.values)]
    end
  end

  # Instance method to run the application server
  def start
    Rack::Server.start(app: self, server: :thin, Port: @port,
                       debug: debug?)
  end



  get '/' do
    [instance.template.render(instance)]
  end

  get '/assets/*url' do |url|
    puts ">>>>>>>>>>. ", instance.environment
    instance.environment
  end

end
