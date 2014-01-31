module Susanoo
  module Generators
    class NgModule < Thor::Group
      include Thor::Actions

      desc "Create an AngularJS module."

      argument :name, :type => :string, :desc => "Name of AngularJS"
      def test
        puts "Adasdasd> #{name}"
      end
    end
  end
end
