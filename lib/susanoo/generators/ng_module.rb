module Susanoo
  module Generators
    class NgModule < Thor::Group
      include Thor::Actions

      desc "Create an AngularJS module."

      argument :name, :type => :string, :desc => "Name of AngularJS"

      def self.is_global_generator?
        false
      end

      def install_templates
        puts "Adasdasd> #{name}"
      end
    end
  end
end
