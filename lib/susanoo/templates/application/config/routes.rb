ROUTER = Lotus::Router.new do
  get '/', to: Susanoo::Application::Index
  get '/views/*', to: Susanoo::Application::Views
  get '/assets/*', to: Susanoo::Application::Assets.new.environment
end
