module Susanoo
  module Generators
    class Frameworks < Thor::Group
      include Thor::Actions

      @bower_data = {
        name: "",
        dependencies: {},
      }

      def ask_for_framework

        @bower_data[:name] = Susanoo::Project.folder_name
        @bower_data[:dependencies][:angular] = "1.2.6"

        if yes? "Do you need Zurb Foundation? (y/n)"
          @bower_data[:dependencies][:foundation] = "*"
          return
        end
        if yes? "What aboud ionic framewor? (y/n)"
          @bower_data[:dependencies][:ionic] = "*"
        end


        inside Susanoo::Project.folder_name do
          inside 'www' do

          end
        end

      end

      private

    end
  end
end
