require 'rack'

class Susanoo::Application

  # This controller is responsible for serving/building index.html file.
  class Index < Susanoo::Controller
    def call(env)
      # Tilt template object
      template = Tilt.new(File.join(project_root, 'src/index.html.erb'))
      [200, {'Content-Type' => 'text/html'}, [template.render(self)]]
    end

    def build(generator, options)
      platform = options[:platform]

      # Configure Sprockets::Helpers (if necessary)
      Sprockets::Helpers.configure do |config|
        config.environment = @environment
        config.prefix      = "/#{platform}_asset/www/assets"
        config.debug       = false
      end

      template = Tilt.new(File.join(project_root, 'src/index.html.erb'))
      data = template.render(self)
      # God forgive me for hard coding this part
      generator.create_file 'www/index.html', data
    end
  end

end
