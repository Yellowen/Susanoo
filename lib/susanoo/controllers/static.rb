require 'rack'

class Susanoo::Application

  # This controller is responsible for serving/building static files.
  # It does not supports regex at this time.
  class Static < Susanoo::Controller
    # TODO: Add regext support to this controller
    def call(env)
      path = env['REQUEST_PATH']
      file = ::File.join(project_root, 'src', path)
      if ::File.exist? file
        [200,
         {'Content-Type' => 'text/plain'},
         [::File.new(file).read]]
      else
        [404,
         {},
         ['Can not find the file']]
      end
    end

    def build(generator, route)
      file = route.path_for_generation[1..-1]
      generator.copy_file file, "www/#{route.path_for_generation}"
    end
  end

end
