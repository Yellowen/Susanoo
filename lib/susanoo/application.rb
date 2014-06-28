require 'rack'

class Susanoo::Application

  class Index < Susanoo::Controller
    def call(env)
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

  class Assets < Susanoo::Controller
    def call(env)
      # [200, {'Content-Type' => 'text/html'}, [environment]]
      run environment
    end
  end

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
