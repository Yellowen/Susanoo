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

require 'rake'
require 'rake/sprocketstask'
require 'uglifier'
require 'yui/compressor'

assets = Sprockets::Environment.new
assets.append_path File.join(Dir.pwd,
                             'src/assets/javascripts')
assets.append_path File.join(Dir.pwd,
                             'src/assets/stylesheets')

Rake::SprocketsTask.new do |t|
  t.environment = assets
  t.output = File.join(Dir.pwd, 'www/assets/')
  t.assets = %w(application.css application.js)
  t.environment.css_compressor = YUI::CssCompressor.new
  t.environment.js_compressor = Uglifier.new(:mangle => true)
end.define
