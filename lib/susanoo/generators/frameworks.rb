module Susanoo
  module Generators
    class Frameworks < Thor::Group
      include Thor::Actions
      source_root File.expand_path('../../templates/application', __FILE__)

      @@bower_data = {
        :name => 'temp_name',
        :dependencies => {
          # TODO: Set this to new version of angular
          angular: '1.2.9',
          'angular-touch' => '*',
          'angular-gestures' => '*',
          'angular-route' => '*',
          'angular-animate' => '*',
          'angular-sanitize' => '*',
          'angular-resource' => '*',
          'angular-gettext' => '*',
          'jquery' => '*',
          'lodash' => '*',
        },
      }

      @@js_files = ['jquery/dist/jquery',
                    'lodash/dist/lodash',
                    'angular/angular',
                    'angular-animate/angular-animate',
                    'angular-route/angular-route',
                    'angular-sanitize/angular-sanitize',
                    'angular-touch/angular-touch',
                    'angular-gestures/gestures',
                    'angular-gettext/dist/angular-gettext',
                    'angular-resource/angular-resource',
                   ]
      @@js_dirs = []
      @@css_files = []
      @@css_dirs = []

      def susanoo_files
        template 'Gemfile', "#{Susanoo::Project.folder_name}/Gemfile"
        template 'Rakefile', "#{Susanoo::Project.folder_name}/Rakefile"
        directory 'config', "#{Susanoo::Project.folder_name}/config"
        template '.gitignore', "#{Susanoo::Project.folder_name}/.gitignore"
        template 'bin/susanoo', "#{Susanoo::Project.folder_name}/bin/susanoo"
      end

      def bower_install
        require 'json'
        inside Susanoo::Project.folder_name do
          inside 'src' do
            create_file 'bower.json' do
              JSON.pretty_generate(@@bower_data)
            end
            system 'bower install'
          end
        end
      end

      def install_templates
        copy_file 'src/index.html.erb', "#{Susanoo::Project.folder_name}/src/index.html.erb"
        template 'src/views/main.html', "#{Susanoo::Project.folder_name}/src/views/main.html"
        template 'src/assets/javascripts/application.js', "#{Susanoo::Project.folder_name}/src/assets/javascripts/application.js"
        template 'src/assets/javascripts/functions.js', "#{Susanoo::Project.folder_name}/src/assets/javascripts/functions.js"
        template 'src/assets/javascripts/variables.js', "#{Susanoo::Project.folder_name}/src/assets/javascripts/variables.js.erb"

        create_file "#{Susanoo::Project.folder_name}/src/assets/javascripts/modules/.keep" do
          " "
        end
        template 'src/assets/javascripts/app.js', "#{Susanoo::Project.folder_name}/src/assets/javascripts/app.js"
        template 'src/assets/javascripts/main.js', "#{Susanoo::Project.folder_name}/src/assets/javascripts/main.js"
        template 'src/assets/stylesheets/application.css', "#{Susanoo::Project.folder_name}/src/assets/stylesheets/application.css"
        template 'src/assets/stylesheets/main.scss', "#{Susanoo::Project.folder_name}/src/assets/stylesheets/main.scss"

        @source_paths << File.expand_path("#{Susanoo::Project.folder_name}/src/bower_components/")
        @@js_files.each do |file|
          unless file == 'angular-ui-router'
            copy_file "#{file}.js", "#{Susanoo::Project.folder_name}/src/assets/javascripts/lib/#{file}.js"
          end
        end

        @@js_dirs.each do |dir|
          directory dir, "#{Susanoo::Project.folder_name}/src/assets/javascripts/lib/#{dir}"
        end

        @@css_files.each do |file|
          copy_file "#{file}.scss", "#{Susanoo::Project.folder_name}/src/assets/stylesheets/lib/#{file}.scss"
        end

        @@css_dirs.each do |dir|
          directory dir, "#{Susanoo::Project.folder_name}/src/assets/stylesheets/lib/#{dir}"
        end

      end

      def remove_temp
        if yes? 'Do want to remove unneccessary files? (y/n)'.colorize(:red)
          remove_dir "#{Susanoo::Project.folder_name}/src/bower_components"
        end
      end

      def self.is_global_generator?
        true
      end

      private

      def js_dirs
        @@js_dirs
      end

      def js_files
        @@js_files
      end
    end
  end
end
