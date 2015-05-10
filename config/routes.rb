FantasyLeagueFinder::Application.routes.draw do
  root to: 'api/v1/posts#create'

  # used in js routes
  resources :sessions, controller: 'api/v1/sessions'
  resources :posts, controller: 'api/v1/posts'
  resources :users, controller: 'api/v1/users'

  namespace :api do
    namespace :v1 do
      resources :posts
      resources :users
      resources :replies
      resources :sessions
      get '/league_scrapers/:url', to: 'league_scrapers#show', as: :league_scraper, constraints: {url: /.+/}, defaults: {format: :json}
      get 'login', to: 'sessions#create', as: :login
    end
  end
end
