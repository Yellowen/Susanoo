# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'susanoo/version'

Gem::Specification.new do |spec|
  spec.name          = "susanoo"
  spec.version       = Susanoo::VERSION
  spec.authors       = ["Sameer Rahmani"]
  spec.email         = ["lxsameer@gnu.org"]
  spec.description   = %q{ Develop mobile application using apache cordova and ruby utilities. }
  spec.summary       = %q{ Develop mobile application using apache cordova and ruby utilities. Take advantage of ruby gems to rapidly develop mobile applications}
  spec.homepage      = "http://github.com/lxsameer/Susanoo"
  spec.license       = "GPL-2"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_dependency "thor"
  spec.add_dependency "colorize"

end
