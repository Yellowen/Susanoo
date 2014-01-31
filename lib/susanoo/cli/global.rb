require 'thor'
require 'susanoo/generators'


module Susanoo
  module CLI
    class Global < Thor

      desc "new PROJECT", "Create a new Susanoo/Cordova project"
      def new(name)
        Susanoo::Project.folder_name = name
        Susanoo::Generators::Cordova.start

        Susanoo::Generators::Frameworks.start
      end

    end
  end
end
