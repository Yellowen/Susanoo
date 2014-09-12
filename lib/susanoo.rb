require 'susanoo/version'
require 'erb'
require 'sprockets'
require 'sprockets-helpers'
require 'rack/rewrite'
require 'tilt'
require 'colorize'
require 'lotus/router'
require 'active_support'
#require 'active_support/core_ext/string/inflections'

module Susanoo
end

require 'susanoo/static_generator'
require 'susanoo/controller'
require 'susanoo/project'
require 'susanoo/cli'
require 'susanoo/application'
