module Susanoo
  module Generators
    class Scaffold < Thor::Group
      include Thor::Actions

      desc "Create an scaffold."

      argument :name, :type => :string, :desc => "Name of scaffold"

      def self.global_generator?
        false
      end

      def test
        puts "Adasdasd"
      end

    end
  end
end
