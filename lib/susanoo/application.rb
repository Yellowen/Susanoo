class Susanoo::Application
  include SimpleRouter::DSL
  include Sprockets::Helpers

  attr_accessor :environment
  attr_accessor :debug

  get '/' do
    [
     200,
     {
       'Content-Type'  => 'text/html',
       'Cache-Control' => 'public, max-age=86400'
     },
     [@template.render(App.new(@assets))]
    ]
  end

  get '/assets/*' do
    run @assets
  end



  def initialize(project_root, deubg = true)
    @debug = true
    @root = project_root

    @assets = Sprockets::Environment.new(project_root) do |env|
      env.logger = Logger.new(STDOUT)
    end
    @assets.append_path(File.join(project_root, 'www', 'assets'))
    @assets.append_path(File.join(project_root, 'www', 'assets', 'javascripts'))
    @assets.append_path(File.join(project_root, 'www', 'assets', 'stylesheets'))
    @assets.append_path(File.join(project_root, 'www', 'assets', 'images'))
    @assets.append_path(File.join(project_root, 'www', 'assets', 'fonts'))

    @template = Tilt.new(File.expand_path(project_root, 'www/index.html.erb'))


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
    Rack::Server.start(app: self, server: :thin, Port: 3000,
                       debug: debug?)
  end
end
