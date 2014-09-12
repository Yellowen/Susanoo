require 'rack'

class Susanoo::Application
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

    def build(generator, options)
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
