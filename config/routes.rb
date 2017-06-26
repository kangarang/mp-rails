Rails.application.routes.draw do
  # root to: "application#index"

  # resources :users
  # resources :matchings

  # resources :events
  # resources :artists

# GraphQL
  resources :user, :only => [:index, :show]
  post '/graphql', to: 'graphql#query'

  mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"

  get '/users'                => 'users#index'
  post '/users/new'           => 'users#create'
  put '/users/:uid'           => 'users#update'

  # get "/users/:uid"           => "users#render_potentials"
  # get "/users/new_day/:uid"   => "users#new_day_button"
  get '/users/:uid' => 'users#new_day_button'
  get '/service-worker.js' => "users#service"
  get '/users/profile/:uid'   => 'users#get_profile'

  post '/users/:uid'          => 'users#black_list'
  post '/users/potentials/:uid' => 'users#yes_please'
  get '/users/matches/:uid'   => 'matchings#show_matches'

  get '/matchings'            => 'matchings#index'
  get '/blacklists'           => 'matchings#show_black'
  get '/potentials'           => 'matchings#potentials_index'

  get '/artists'              => 'artists#index'

  get '/events'               => 'events#index'
  delete '/events/delete'     => 'events#destroy'
end
