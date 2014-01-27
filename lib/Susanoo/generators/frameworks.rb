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
          "angular-gestures" => "*",
          "angular-route" => "*",
          "angular-animate" => "*",
          "angular-sanitize" => "*",
          "angular-resource" => "*",
          "jquery" => "*",
          "lodash" => "*",
        },
      }

      @@js_files = ["jquery/jquery",
                    "lodash/dist/lodash",
                    "angular-animate/angular-animate",
                    "angular-route/angular-route",
                    "angular-sanitize/angular-sanitize",
                    "angular-touch/angular-touch",
                    "angular-gestures/gestures",
                    "angular-resource/angular-resource",
                   ]
      @@js_dirs = []
      @@css_files = []
      @@css_dirs = []

      @@is_foundation = false
      @@is_ionic = false

      def susanoo_files
        template "Gemfile", "#{Susanoo::Project.folder_name}/Gemfile"
        template "Rakefile", "#{Susanoo::Project.folder_name}/Rakefile"
        template "config.ru", "#{Susanoo::Project.folder_name}/config.ru"
      end

      def ask_for_framework
        @@bower_data[:name] = Susanoo::Project.folder_name

        if yes? "Do you need Zurb Foundation? (y/n)"
          @@bower_data[:dependencies][:foundation] = "*"
          copy_file "lib/foundation/scss/foundation.scss", "#{Susanoo::Project.folder_name}/www/assets/stylesheets/lib/foundation.scss"
          directory "lib/foundation/scss/foundation", "#{Susanoo::Project.folder_name}/www/assets/stylesheets/lib/foundation"

          @@js_files.concat ["modernizr/modernizr",
                             "foundation/js/foundation"]
          @@is_foundation = true
          return
        end

        if yes? "What aboud ionic framewor? (y/n)"
          @@bower_data[:dependencies][:ionic] = "*"
          @@js_files.concat(["ionic/js/ionic"])
          @@js_dirs.concat(["ionic/js/ext"])
          @@css_dirs.concat(["ionic/scss"])
          @is_ionic = true
        end
      end

      def bower_install
        require "json"
        inside Susanoo::Project.folder_name do
          inside "www" do
            create_file "bower.json" do
              JSON.pretty_generate(@@bower_data)
            end
            system "bower install"
          end
        end
      end

      def install_templates
        template "www/index.html", "#{Susanoo::Project.folder_name}/www/index.html"
        template "www/assets/javascripts/application.js", "#{Susanoo::Project.folder_name}/www/assets/javascripts/application.js"
        template "www/assets/javascripts/app.js", "#{Susanoo::Project.folder_name}/www/assets/javascripts/app.js"
        template "www/assets/javascripts/main.js", "#{Susanoo::Project.folder_name}/www/assets/javascripts/main.js"
        template "www/assets/stylesheets/application.css", "#{Susanoo::Project.folder_name}/www/assets/stylesheets/application.css"

        @source_paths << File.expand_path("#{Susanoo::Project.folder_name}/www/bower_components/")

        @@js_files.each do |file|
          copy_file "#{file}.js", "#{Susanoo::Project.folder_name}/www/assets/javascripts/lib/#{file}.js"
        end

        @@js_dirs.each do |dir|
          directory dir, "#{Susanoo::Project.folder_name}/www/assets/javascripts/lib/#{dir}"
        end

        @@css_files.each do |file|
          copy_file "#{file}.scss", "#{Susanoo::Project.folder_name}/www/assets/stylesheets/lib/#{file}.scss"
        end

        @@css_dirs.each do |dir|
          directory dir, "#{Susanoo::Project.folder_name}/www/assets/stylesheets/lib/#{dir}"
        end

      end

      def remove_temp
        if yes? "Do want to remove unneccessary files? (y/n)".colorize(:red)
          remove_dir "#{Susanoo::Project.folder_name}/www/bower_components"
        end
      end
      private

      def is_foundation?
        @@is_foundation
      end

      def is_ionic?
        @@is_ionic
      end

    end
  end
end
