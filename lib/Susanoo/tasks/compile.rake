desc "Asdasd"
task :assets do

require "sprockets"
#require "rake/sprocketstask"

assets = Sprockets::Environment.new
assets.append_path "assets/javascripts"
assets.append_path "assets/stylesheets"
assets.append_path "assets/images"
LOOSE_APP_ASSETS = lambda do |path, filename|
  filename !~ %r~assets~  && !%w[.js .css].include?(File.extname(path))
end
precompile = [LOOSE_APP_ASSETS, /(?:\/|\\|\A)application\.(css|js)$/]
#binding.pry
  assets.each_logical_path(*precompile).each {|path|
    assets[path].write_to "statics/#{path}"
    }
end
