require 'rack'

class Susanoo::Application

  class Index < Susanoo::Controller
    def call(env)
      template = Tilt.new(File.join(project_root, 'www/index.html.erb'))
      [200, {'Content-Type' => 'text/html'}, [template.render(self)]]
    end
  end

  class Assets < Susanoo::Controller
    def call(env)
      [200, {'Content-Type' => 'text/html'}, environment]
    end
  end

  class Views < Susanoo::Controller
    def call(env)
      #template = Tilt.new(File.join(project_root, 'www/index.html.erb'))
      [200, {'Content-Type' => 'text/html'}, ["asdasd"]]
    end
  end

end
