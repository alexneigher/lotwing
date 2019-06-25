Rails.application.routes.draw do
  # for javascript clients
  namespace :web_api do
    resources :events
    resources :shapes do
      collection do
        get :parking_lots
        get :buildings
        get :parking_spaces
      end
    end
  end

  #for Mobile clients
  namespace :api do
    post "auth/login", controller: :authentication, action: :login
    get "auth/test", controller: :authentication, action: :test #for testing purposes

    namespace :vehicles do
      resources :stock_numbers, param: :stock_number, only: [:index, :show]
    end
    
    resources :vehicles
    resources :events

    resources :shapes do
      collection do
        get :parking_lots
        get :buildings
        get :parking_spaces
      end
    end
    resources :tags, only: :create
  end

  devise_for :users

  root "board_managers#show"

  resources :dealer_trades do
    get :trade_sheet
    collection do
      put :stock_number_search
      put :previous_trade_search
    end
  end

  resources :check_requests do
    get :printout
    collection do
      put :stock_number_search
      get :search
    end
  end

  resources :suggested_trade_dealerships, only: :destroy
  
  resources :service_license_agreement, only: [:new, :create]
  
  resources :key_board_locations, only: [:create]

  # UI for drawing shapes on the map and saving them
  get :map_builder, to: 'home#map_builder'

  get :lot_view, to: 'home#show'

  scope "/invitations/:reset_password_token/", as: :invitations, controller: :invitations do
    get :view_invitation
    put :accept_invitation
  end

  resources :shapes

  resources :events, only: [:show, :update] do
    resources :resolutions, controller: 'events/resolutions'
  end

  resources :dealerships, only: [:edit, :update] do
    resources :users, only: [:new, :create, :show, :destroy], controller: 'dealerships/users'
  end
  
  resources :vehicles do
    collection do
      get :search
    end
  end

  resource :board_manager, path: '/board-manager' do
    collection do
      get :stored_deals
      get :new_vehicle_report
      get :rdr_report
      get :used_vehicle_report
      get :running_total
      get :cpo_report
    end
  end

  resources :deals, except: [:index] do
    get :cover_sheet
    collection do
      put :stock_number_search
    end
  end

  resources :tags do
    get :deactivate
  end
end
