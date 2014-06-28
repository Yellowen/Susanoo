require 'rack'

# This class contains basic controllers which is needed for Susanoo to
# work. Each controller should contains `call` and `build` instance methods.
# `call` is responsible to serving an http request base on **Rack** specification
# and `build` is responsible to create static files with suitable content. `build`
# method gets an argumant which is the generator object that calls build methods.
# `generator` is a **Thor** object so you can use **Thor::Actions** in your method.
class Susanoo::Application

  # This controller is responsible for serving/building index.html file.
  class Index < Susanoo::Controller
    def call(env)
      # Tilt template object
      template = Tilt.new(File.join(project_root, 'src/index.html.erb'))
      [200, {'Content-Type' => 'text/html'}, [template.render(self)]]
    end

    def build(generator)
      template = Tilt.new(File.join(project_root, 'src/index.html.erb'))
      data = template.render(self)
      # God forgive me for hard coding this part
      generator.create_file 'www/index.html', data
    end
  end

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

      system  'cp src/assets/images www/assets/images -rv'
      system  'cp src/assets/fonts www/assets/fonts -rv'

    end
  end

  # This controller is responsible to serving/building angularjs templates.
  class Views < Susanoo::Controller
    def call(env)
      path =  env['PATH_INFO']
      if File.exist?(File.join(project_root, "src/views#{path}.erb"))
        template = Tilt.new(File.join(project_root, "src/views#{path}.erb"))
      elsif File.exist?(File.join(project_root, "src/views#{path}"))
        template = Tilt.new(File.join(project_root, "src/views#{path}"))
      else
        fail "There is no '#{path}' in 'src/views' directory."
      end
      [200, {'Content-Type' => 'text/html'}, [template.render(self)]]
    end
  end

end
