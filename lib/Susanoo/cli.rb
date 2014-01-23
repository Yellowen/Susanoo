require 'thor'
require 'Susanoo/generators'


module Susanoo
  class Cli < Thor
    desc "new PROJECT", "Create a new Susanoo/Cordova project"
    def new(name)
      Susanoo::Project.folder_name = name
      Susanoo::Generators::Cordova.start

      Susanoo::Generators::Frameworks.start
    end
  end
end
