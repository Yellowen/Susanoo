require "bundler/setup"

Bundler.require

desc "Compile assets into statics folder"
task :assets do
  require "sprockets"
  #require "rake/sprocketstask"

  assets = Sprockets::Environment.new
  assets.append_path "www/assets/javascripts"
  assets.append_path "www/assets/stylesheets"

  Susanoo::Assets.path = ""
  LOOSE_APP_ASSETS = lambda do |path, filename|
    filename !~ %r~assets~  && !%w[.js .css].include?(File.extname(path))
  end
  precompile = [LOOSE_APP_ASSETS, /(?:\/|\\|\A)application\.(css|js)$/]
  assets.each_logical_path(*precompile).each {|path|
    assets[path].write_to "www/statics/#{path}"
  }

  system  "cp www/assets/images www/statics/images -rv"
  system  "cp www/assets/fonts www/statics/fonts -rv"
end
