module Susanoo
    class Application
    @@debug = false

    def self.debug?
      @@debug
    end

    def self.debug=(value)
      @@debug = value
    end

  end
end
