require 'susanoo/generators'

module Susanoo::CLI
  module Commands
    # Provide the `generate` & `destroy` commands for project wide usage.
    module Generate
      extend ::ActiveSupport::Concern

      included do
        map 'g' => :generate
        map 'd' => :destroy

        desc 'generate GENERATOR [options]', 'Run the given generator'
        def generate(generator_name = nil, *options)
          generator = get_the_generator_class generator_name
          # Run the generator with given options
          generator.start(options, behavior: :invoke,
                          destination_root: project_root)
        end

        desc 'destroy GENERATOR [options]', 'Destroy the given generator'
        def destroy(generator_name = nil, *options)
          generator = get_the_generator_class generator_name

          generator.start(options, behavior: :revoke,
                          destination_root: project_root)
        end

      end

      private

      def get_the_generator_class(generator_name)
        # Print the generators list and exit
        if generator_name.nil?
          print_generator_list
          return
        end

        # Try to load and get the generator Class
        begin
          klass = generator_name.downcase.camelize
          generator = Susanoo::Generators.const_get(klass)

        rescue NameError
          say_status 'Error', "Generator `#{generator_name}` not found.",
                     :red
          exit 1
        end
        generator
      end

    end
  end
end
