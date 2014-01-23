module Susanoo
  module Generators
    class Frameworks < Thor::Group
      include Thor::Actions

      @bower_data = {
        :name => "",
        :dependencies => {
          angular: "1.2.6",
          "angular-touch" => "*",
          "angular-gesture" => "*",
        },
      }

      @js_files = ["modernizr/modernizr",
                   "jquery/jquery",
                   "lodash/dist/lodash",
                   "angular-touch/angular-touch",
                   "angular-gesture/ngGesture/gesture.js"]
      @css_files = []

      def ask_for_framework

        @bower_data[:name] = Susanoo::Project.folder_name

        if yes? "Do you need Zurb Foundation? (y/n)"
          @bower_data[:dependencies][:foundation] = "*"
          @css_files << "foundation/scss/foundation"
          @js_files << "foundation/js/foundation"
          return
        end
        if yes? "What aboud ionic framewor? (y/n)"
          @bower_data[:dependencies][:ionic] = "*"
          @js_files << "ionic/js/ionic"
          @css_files << "ionic/scss/ionic"

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
