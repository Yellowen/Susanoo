require "bundler/setup"

Bundler.require

desc "Compile assets into statics folder"
task :assets1 do
  require "sprockets"
  #require "rake/sprocketstask"

  assets = Sprockets::Environment.new
  assets.append_path "src/assets/javascripts"
  assets.append_path "src/assets/stylesheets"

  #Susanoo::Assets.path = ""
  LOOSE_APP_ASSETS = lambda do |path, filename|
    puts ">>>>>>>>>>>>>>>>>>>> ", filename,     filename !~ %r~assets~  && !%w[.js .css].include?(File.extname(path))
    filename !~ %r~assets~  && !%w[.js .css].include?(File.extname(path))
  end
  puts ">>>>>"
  precompile = [LOOSE_APP_ASSETS, /(?:\/|\\|\A)application\.(css|js)$/]
  assets.each_logical_path(*precompile).each {|path|
    puts "<$$$$$$ ", File.extname(path)
    dir = ''
    case File.extname(path)
    when '.js'
      dir = 'javascripts'
    when '.css'
      dir = 'stylesheets'
    end
    puts "<<<<<<<<<<<<<<<< ", dir
    assets[path].write_to "www/assets/#{dir}/#{path}"
  }

  #system  "cp www/assets/images www/statics/images -rv"
  #system  "cp www/assets/fonts www/statics/fonts -rv"
end
