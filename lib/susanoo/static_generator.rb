require 'set'

module Susanoo
  class StaticGenerator

    @@classes = Set.new

    def self.register(klass)
      @@classes << klass
    end

    def self.classes
      @@classes.to_a
    end

  end
end
