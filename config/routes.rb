Rails.application.routes.draw do

    root to: "application#index"

    resources :users
    resources :matchings

    # resources :events
    # resources :artists

end
