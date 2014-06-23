module Susanoo
  class Controller

    include Sprockets::Helpers

    attr_accessor :environment
    attr_accessor :debug

    def initialize
      project_root = Susanoo::Project.path

      @environment = Sprockets::Environment.new(project_root) do |env|
        env.logger = Logger.new(STDOUT)
      end

      @environment.append_path(File.join(project_root, 'www', 'assets'))
      @environment.append_path(File.join(project_root, 'www', 'assets', 'javascripts'))
      @environment.append_path(File.join(project_root, 'www', 'assets', 'stylesheets'))
      @environment.append_path(File.join(project_root, 'www', 'assets', 'images'))
      @environment.append_path(File.join(project_root, 'www', 'assets', 'fonts'))

    end

  end
end
