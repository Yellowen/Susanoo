# If you need to use your own controllers
# define them in your `lib` and require them here
ROUTER = Lotus::Router.new do
  get '/', to: Susanoo::Application::Index
  get '/views/*', to: Susanoo::Application::Views
  get '/assets/*', to: Susanoo::Application::Assets.new.environment
end
