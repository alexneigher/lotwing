Rails.application.routes.draw do
  namespace :api do
    resources :events
    resources :shapes do
      collection do
        get :parking_lots
        get :buildings
        get :parking_spaces
      end
    end
  end

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "home#show"

  # UI for drawing shapes on the map and saving them
  get :map_builder, to: 'home#map_builder'

  resources :shapes

  resources :events, only: [:show, :update] do
    resources :resolutions, controller: 'events/resolutions'
  end

  resources :dealerships, only: [:update]
  
  resources :vehicles do
    collection do
      get :vin_search
    end
  end

  resource :board_manager, path: '/board-manager'

  resources :tags do
    get :deactivate
  end
end
