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
          @@css_files << "foundation/scss/foundation"
          @@js_files << "foundation/js/foundation"
          return
        end

        if yes? "What aboud ionic framewor? (y/n)"
          @@bower_data[:dependencies][:ionic] = "*"
          @@js_files << "ionic/js/ionic"
          @@css_files << "ionic/scss/ionic"

        end
      end

      def bower_install
        require "json"
        inside Susanoo::Project.folder_name do
          inside "www" do
            create_file "bower.json" do
              JSON.generate(@@bower_data)
            end
            system "bower install"
          end
        end
      end

      def install_templates
        abs_path = File.expand_path("", Susanoo::Project.folder_name)
        template "www/index.html", "#{Susanoo::Project.folder_name}/www/index.html"
        template "www/assets/javascripts/application.js", "#{Susanoo::Project.folder_name}/www/assets/javascripts/application.js"
        template "www/assets/stylesheets/application.css", "#{Susanoo::Project.folder_name}/www/assets/stylesheets/application.css"

        inside Susanoo::Project.folder_name do
          inside "www" do
            inside "assets" do
              inside "stylesheets" do

                empty_directory "lib"
                @@css_files.each do |x|
                  system "cp -v #{abs_path}/www/bower_components/#{x}.scss #{abs_path}/www/assets/stylesheets/#{x}.scss"
                end
              end
            end
          end
        end
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
