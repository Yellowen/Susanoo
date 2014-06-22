class Susanoo::Applicaion
  include SimpleRouter::DSL
  include Sprockets::Helpers

  attr_accessor :environment
  attr_accessor :debug

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

  end

  def debug?
    @debug
  end

  get '/' do
    [
     200,
     {
       'Content-Type'  => 'text/html',
       'Cache-Control' => 'public, max-age=86400'
     },
     [template.render(App.new(@assets))]
    ]
  end

  get '/assets/*' do
    run @assets
  end

  def call(env)
    verb, path  = ENV['REQUEST_METHOD'], ENV['PATH_INFO']
    route = self.class.routes.match(verb, path)

    route.nil? ?
    [404, {'Content-Type' => 'text/html'}, '404 page not found'] :
      [200, {'Content-Type' => 'text/html'}, route.action.call(*route.values)]
  end
end
