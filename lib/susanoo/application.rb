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
      generator.say_status 'copy', 'src/assets/images'
      `cp #{project_root}/src/assets/images #{project_root}/www/assets/images -rv`
      generator.say_status 'copy', 'src/assets/fonts'
      `cp #{project_root}/src/assets/fonts #{project_root}/www/assets/fonts -rv`

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

    def build(generator)
      file_pattern = File.join(project_root, 'src/views/**/*.{html,html.erb}')
      dest_path = File.join(project_root, 'www')
      src_path = File.join(project_root, 'src')

      Dir.glob(file_pattern) do |file|
        template = Tilt.new file

        dest_file = File.join(dest_path,
                              file.gsub(src_path, ''))

        # Create missing directories in destination path
        FileUtils.mkpath dest_path

        # Remove erb extension name from destination path
        dest_file.gsub!('.erb', '') if File.extname(dest_file) == 'erb'

        # Create the destination file
        generator.create_file dest_file, template.render(self)
      end
    end
  end

end
