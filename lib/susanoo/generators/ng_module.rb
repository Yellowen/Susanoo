module Susanoo
  module Generators
    class NgModule < Thor::Group
      include Thor::Actions

      desc 'Create an AngularJS module.'

      argument :name, type: :string, desc: 'Name of AngularJS'
      class_option :deps, type: :string, default: '', desc: 'Dependencies of Angularjs module, comma separated'

      def self.source_root
        File.join(File.dirname(__FILE__),
                  '../templates/generators/ng_module')
      end

      def self.global_generator?
        false
      end

      def setup_directories
        unless directory_name.nil?
          empty_directory "src/views/#{directory_name}"
          empty_directory "src/assets/javascripts/modules/#{directory_name}"
        end
      end

      def install_js_module
        template 'module.js.erb', "src/assets/javascripts/modules/#{directory_name}/#{module_name}.js"
      end

      private

      def directory_name
        dir_name = name.split('/')[0..-2].join('/')
        return dir_name unless dir_name.empty?
        nil
      end

      def module_name
        name.split('/')[-1].underscore
      end

      def dependencies
        options[:deps].split(',')
      end
    end
  end
end
