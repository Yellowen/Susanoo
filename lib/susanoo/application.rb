require 'rack'

# This class contains basic controllers which is needed for Susanoo to
# work. Each controller should contains `call` and `build` instance methods.
# `call` is responsible to serving an http request base on **Rack** specification
# and `build` is responsible to create static files with suitable content. `build`
# method gets an argumant which is the generator object that calls build methods.
# `generator` is a **Thor** object so you can use **Thor::Actions** in your method.
class Susanoo::Application
end

require 'susanoo/controllers/index'
require 'susanoo/controllers/views'
require 'susanoo/controllers/assets'
