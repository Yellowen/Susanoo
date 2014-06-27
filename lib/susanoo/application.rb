require 'rack'

class Susanoo::Application

  class Index < Susanoo::Controller
    def call(env)
      template = Tilt.new(File.join(project_root, 'www/index.html.erb'))
      [200, {'Content-Type' => 'text/html'}, [template.render(self)]]
    end

    def build
      template = Tilt.new(File.join(project_root, 'www/index.html.erb'))

      File.open(File.join(project_root, 'www/.build/index.html'), 'w') do |f|
        f.puts template.render(self)
      end
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
      if File.exist?(File.join(project_root, "www/views#{path}.erb"))
        template = Tilt.new(File.join(project_root, "www/views#{path}.erb"))
      elsif File.exist?(File.join(project_root, "www/views#{path}"))
        template = Tilt.new(File.join(project_root, "www/views#{path}"))
      else
        fail "There is no '#{path}' in 'www/views' directory."
      end
        [200, {'Content-Type' => 'text/html'}, [template.render(self)]]
    end
  end

end
