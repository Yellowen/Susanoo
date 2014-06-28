require 'rack'

class Susanoo::Application

  # This controller is responsible for serving/building assets files
  class Assets < Susanoo::Controller
    def call(env)
      # Environment is a sprockets environment instance
      run environment
    end

    def build(generator)
      assets = Sprockets::Environment.new
      assets.append_path "src/assets/javascripts"
      assets.append_path "src/assets/stylesheets"

      func = lambda do |path, filename|
        filename !~ %r~assets~  && !%w[.js .css].include?(File.extname(path))
      end
      precompile = [func, /(?:\/|\\|\A)application\.(css|js)$/]
      assets.each_logical_path(*precompile).each {|path|
        assets[path].write_to "www/assets/#{path}"
      }
      generator.say_status 'copy', 'src/assets/images'
      `cp #{project_root}/src/assets/images #{project_root}/www/assets/images -rv`
      generator.say_status 'copy', 'src/assets/fonts'
      `cp #{project_root}/src/assets/fonts #{project_root}/www/assets/fonts -rv`

    end
  end
end
