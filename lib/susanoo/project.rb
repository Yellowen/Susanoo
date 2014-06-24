module Susanoo
  class Project
    class << self
      attr_accessor :folder_name
      attr_accessor :project_name
      attr_accessor :package_name
      attr_accessor :path
      attr_accessor :debug
    end
  end
end
