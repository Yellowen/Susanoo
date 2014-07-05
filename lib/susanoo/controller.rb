require 'thor'
require 'thor/actions'

module Susanoo
  class Controller

    include Sprockets::Helpers

    attr_accessor :environment
    attr_accessor :debug
    attr_accessor :project_root

    def initialize
      @project_root = Susanoo::Project.path

      @environment = Sprockets::Environment.new(@project_root) do |env|
        env.logger = Logger.new(STDOUT)
      end

      #@environment.append_path(@project_root)
      @environment.append_path(File.join(@project_root, 'src', 'assets'))
      @environment.append_path(File.join(@project_root, 'src', 'assets', 'javascripts'))
      @environment.append_path(File.join(@project_root, 'src', 'assets', 'stylesheets'))
      @environment.append_path(File.join(@project_root, 'src', 'assets', 'images'))
      @environment.append_path(File.join(@project_root, 'src', 'assets', 'fonts'))

      Susanoo::StaticGenerator.register self.class
    end

    def static_compile?
      @static_compile
    end


  end
end
