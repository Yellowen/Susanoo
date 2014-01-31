module Susanoo
  class Tasks
    def self.load_tasks
      path = File.expand_path("../", __FILE__)
      ::Dir["#{path}/tasks/*.rake"].each do |r|
        load r
      end
    end
  end
end
