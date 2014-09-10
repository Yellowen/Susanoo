require 'rubygems'

require 'pathname'
require 'susanoo/cli/global'
require 'susanoo/cli/project'
require 'active_support/core_ext/string/inflections'


module Susanoo
  module CLI

    EXEC_FILES = ['bin/susanoo']

    def self.run
      unless execute
        Susanoo::CLI::Global.start
      end
    end

    def self.execute
      cwd = Dir.pwd

      loop do
        # Find an executable in bin/susanoo
        # In other word are we in an susanoo project or not?
        # Note: Single equalsign is on purpose
        if exec_file = find_executable

          # Inject path
          inject_dev_path
          exec Gem.ruby, exec_file, *ARGV
          break
        end

        Dir.chdir(cwd) and return false if Pathname.new(Dir.pwd).root?
        Dir.chdir('../')
      end
    end

    def self.inject_dev_path
      if File.exist? File.expand_path('../../../.git', __FILE__)
        ENV['SUSANOO_HOME'] = File.expand_path('../../', __FILE__)
      end
    end

    def self.find_executable
      EXEC_FILES.find { |exe| File.file?(exe) }
    end

  end
end
