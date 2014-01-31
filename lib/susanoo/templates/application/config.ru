require 'sprockets'
require 'rack/rewrite'

project_root = File.expand_path(File.dirname(__FILE__))

assets = Sprockets::Environment.new(project_root) do |env|
  env.logger = Logger.new(STDOUT)
end

assets.append_path(File.join(project_root, 'www', 'assets'))
assets.append_path(File.join(project_root, 'www', 'assets', 'javascripts'))
assets.append_path(File.join(project_root, 'www', 'assets', 'stylesheets'))
assets.append_path(File.join(project_root, 'www', 'assets', 'images'))

map "/statics" do
  run assets
end

map "/" do
  use Rack::Static, :urls => [""], :index => "www/index.html"
  run lambda { |env|
    [
     200,
     {
       'Content-Type'  => 'text/html',
       'Cache-Control' => 'public, max-age=86400'
     },
     aFile.open('www/index.html', File::RDONLY)
    ]
  }
end
