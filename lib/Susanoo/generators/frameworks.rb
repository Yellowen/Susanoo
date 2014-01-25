module Susanoo
  module Generators
    class Frameworks < Thor::Group
      include Thor::Actions
      source_root File.expand_path('../../templates', __FILE__)

      @@bower_data = {
        :name => "",
        :dependencies => {
          angular: "1.2.9",
          "angular-touch" => "*",
          "angular-gesture" => "*",
        },
      }

      @@js_files = ["modernizr/modernizr",
                   "jquery/jquery",
                   "lodash/dist/lodash",
                   "angular-touch/angular-touch",
                   "angular-gesture/ngGesture/gesture.js"]
      @@css_files = []

      def ask_for_framework
        @@bower_data[:name] = Susanoo::Project.folder_name

        if yes? "Do you need Zurb Foundation? (y/n)"
          @@bower_data[:dependencies][:foundation] = "*"
          copy_file "lib/foundation/scss/foundation.scss", "#{Susanoo::Project.folder_name}/www/assets/stylesheets/lib/foundation.scss"
          directory "lib/foundation/scss/foundation", "#{Susanoo::Project.folder_name}/www/assets/stylesheets/lib/foundation"

          copy_file "lib/foundation/js/foundation.js", "#{Susanoo::Project.folder_name}/www/assets/javascripts/lib/foundation.js"
          return
        end

        if yes? "What aboud ionic framewor? (y/n)"
          @@bower_data[:dependencies][:ionic] = "*"
          copy_file "lib/ionic/js/ionic.js", "#{Susanoo::Project.folder_name}/www/assets/javascripts/lib/ionic.js"
          copy_file "lib/ionic/scss/ionic.scss", "#{Susanoo::Project.folder_name}/www/assets/stylesheets/lib/ionic.scss"

        end
      end

      def bower_install
        require "json"
        inside Susanoo::Project.folder_name do
          inside "www" do
            create_file "bower.json" do
              JSON.generate(@@bower_data)
            end
          end
        end
      end

      def install_templates
        abs_path = File.expand_path("", Susanoo::Project.folder_name)
        template "www/index.html", "#{Susanoo::Project.folder_name}/www/index.html"
        template "www/assets/javascripts/application.js", "#{Susanoo::Project.folder_name}/www/assets/javascripts/application.js"
        template "www/assets/stylesheets/application.css", "#{Susanoo::Project.folder_name}/www/assets/stylesheets/application.css"
      end

      def susanoo_files
        template "Gemfile", "#{Susanoo::Project.folder_name}/Gemfile"
        template "Rakefile", "#{Susanoo::Project.folder_name}/Rakefile"
        template "config.ru", "#{Susanoo::Project.folder_name}/config.ru"
      end

      private

      def js_filesx
        @@js_files
      end

      def css_files
        @@css_files
      end

      def bower_data
        @@bower_data
      end
    end
  end
end
