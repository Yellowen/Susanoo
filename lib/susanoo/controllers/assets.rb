require 'rack'
require 'uglifier'
require 'yui/compressor'

class Susanoo::Application

  # This controller is responsible for serving/building assets files
  class Assets < Susanoo::Controller
    def call(env)
      # Environment is a sprockets environment instance
      run environment
    end

    def build(generator, route)
      assets = Sprockets::Environment.new
      assets.append_path File.join(project_root,
                                   'src/assets/javascripts')
      assets.append_path File.join(project_root,
                                   'src/assets/stylesheets')

      func = lambda do |path, filename|
        filename !~ %r~assets~  && !%w[.js .css].include?(File.extname(path))
      end

      precompile = [func, /(?:\/|\\|\A)application\.(css|js)$/]
      assets.each_logical_path(*precompile).each {|path|
        case File.extname(path)
        when '.js'
          dir = 'javascripts'
        when '.css'
          dir = 'stylesheets'
        end
        assets[path].write_to "www/assets/#{dir}/#{path}"
      }

      if File.exist? File.join(project_root,
                               'src/assets/images')
        generator.say_status 'copy', 'src/assets/images'
        `cp #{project_root}/src/assets/images #{project_root}/www/assets/images -r`
      end

      if File.exist? File.join(project_root,
                               'src/assets/fonts')
        generator.say_status 'copy', 'src/assets/fonts'
        `cp #{project_root}/src/assets/fonts #{project_root}/www/assets/fonts -r`
      end
    end
  end
end
