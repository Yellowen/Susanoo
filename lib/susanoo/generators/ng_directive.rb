module Susanoo
  module Generators
    class NgModule < Thor::Group
      include Thor::Actions

      desc 'Create an AngularJS directive.'

      argument :name, type: :string, desc: 'Name of AngularJS directive'
      class_option :deps, type: :string, default: '',
         desc: 'Dependencies of Angularjs module, comma separated'

      class_option :restrict, type: :string, default: 'E',
         desc: 'AngularJS directive restriction types'

      class_option :replace, type: :boolean, default: true,
         desc: 'AngularJS directive replace option'

      # TODO: Add an append class option to allow user
      #       to append the directive to already defined
      #       modules

      def self.source_root
        File.join(File.dirname(__FILE__),
                  '../templates/generators/ng_directive')
      end

      def self.global_generator?
        false
      end

      def setup_directories
        empty_directory "src/views/directives/#{directive_name}"

        mpath = 'src/assets/javascripts/modules/directives'
        empty_directory "#{mpaath}" unless directory_name.nil?
      end

      def install_js_module
        template 'directive.js.erb',
                 "src/assets/javascripts/modules/#{directory_name}#{directive_name}.js"
      end

      def install_view
        template('index.html.erb',
                 "src/views/#{directory_name}#{directive_name}/#{directive_name}.html")
      end

      private

      def directory_name
        dir_name = name.split('/')[0..-2].join('/')
        return dir_name + '/' unless dir_name.empty?
        nil
      end

      def directive_name
        name.split('/')[-1].underscore
      end

      def dependencies
        options[:deps].split(',')
      end
    end
  end
end
