module Susanoo
  module Generators
    class Cordova < Thor::Group
      include Thor::Actions

      CORDOVA_VERSION = `cordova -v`
      CORDOVA_PATH = `which cordova`

      def initialize_project
        fname = Susanoo::Project.folder_name.dup

        # Java Package name
        package_name = ask "Java Package Name: ".colorize(:light_green)
        if package_name.chomp.strip.empty?
          package_name = "com.example.#{fname.gsub("-", "_")}"
        else
          if package_name.chomp.split(".").length < 3
            say "Package name format should be like 'suffix.domain.subdomain'".colorize(:red)
            exit 1
          end
        end

        # Project name
        project_name = ask "Project Name [#{fname.colorize(:light_red)}".colorize(:light_green) + "]: ".colorize(:light_green)

        say "Initializing project with Apache Cordova #{version} at #{CORDOVA_PATH}"
        system "cordova create #{Susanoo::Project.folder_name} #{package_name.chomp} #{project_name.chomp}"
      end

      def platforms
        platforms = ask "Platforms (comma separated): ".colorize(:light_blue)
        inside Susanoo::Project.folder_name do
          platforms.chomp.split(",").each do |platform|
            say "Adding #{platform.strip} platform ...".colorize(:green)
            system "cordova platform add #{platform.strip}"
          end
          say "Adding console plugin to project".colorize(:green)
          system "cordova plugin add org.apache.cordova.console"
        end
      end

      def remove_default_files
        say "Removing cordova default files . . .".colorize(:yellow)
        inside Susanoo::Project.folder_name do
          inside "www" do
            remove_file "index.html"
            remove_file "js"
            remove_file "css"
            remove_file "img"
          end
        end
      end

      def self.is_global_generator?
        true
      end

      private

      def version
        CORDOVA_VERSION.chomp
      end

    end
  end
end
