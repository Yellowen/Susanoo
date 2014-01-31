module Susanoo
  module Generators
    class Scaffold < Thor::Group
      include Thor::Actions
      desc "Create an scaffold."

      argument :name, :type => :string, :desc => "Name of scaffold"
      def test
        puts "Adasdasd"
      end
    end
  end
end
