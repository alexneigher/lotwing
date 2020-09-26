det.application.routes.draw do

  namespace :webhooks do
    resources :payments, only: :create
  end

  # for javascript clients
  namespace :web_api do
    resources :events
    resources :shapes do
      collection do
        get :parking_lots
        get :buildings
        get :landscaping
        get :parking_spaces
      end
    end
  end

  resources :barcodes, only: :create

  resources :detail_jobs do
    put :start_job
    put :complete_job
    put :reset_job
    collection do
      put :stock_number_search
      put :report
    end
  end

  #for Mobile clients
  namespace :api do
    post "auth/login", controller: :authentication, action: :login
    get "auth/test", controller: :authentication, action: :test #for testing purposes

    namespace :vehicles do
      resources :stock_numbers, param: :stock_number, only: [:index, :show]
      resources :vin_search, param: :vin, only: [:show]
    end

    resource :dealership, only: :show

    resources :key_board_locations
    resources :vehicles


    resources :events

    resource :active_drives

    resources :deals do
      collection do
        get :mtd
        get :today
      end
    end

    resources :shapes do
      collection do
        get :parking_lots
        get :buildings
        get :parking_spaces
        get :landscaping
      end
    end
    resources :tags, only: :create
  end

  devise_for :users

  root "board_managers#show"

  resources :dealer_trades do
    get :trade_sheet
    get :print_dealer_trade_sheet
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

  resources :service_tickets do
    collection do
      put :stock_number_search
    end
  end

  resources :service_ticket_departments, only: :update

  resources :notes, only: [:create, :edit, :update]

  resources :suggested_trade_dealerships, only: :destroy

  resources :service_license_agreement, only: [:new, :create]

  resources :key_board_locations, only: [:create, :edit, :update]

  # UI for drawing shapes on the map and saving them
  get :map_builder, to: 'home#map_builder'

  get :lot_view, to: 'home#show'

  namespace :home do
    resources :user_activity, only: :index, controller: 'user_activity'

    get :lot_view_info_bar
  end

  scope "/invitations/:reset_password_token/", as: :invitations, controller: :invitations do
    get :view_invitation
    put :accept_invitation
  end

  resources :shapes

  resources :events, only: [:show, :update] do
    resources :resolutions, controller: 'events/resolutions'
  end

  resources :dealerships, only: [:edit, :update] do
    resources :payment_plans, controller: 'dealerships/payment_plans', only: :create
    resources :users, controller: 'dealerships/users'
    resources :deleted_records, controller: 'dealerships/deleted_records', only: [:index, :update, :destroy]
    resources :team_members, controller: 'dealerships/team_members', only: :index
    resources :custom_fields, controller: 'dealerships/custom_fields', only: :index
    resources :payment_info, controller: 'dealerships/payment_info', only: :index
    resources :detail_job_config, controller: 'dealerships/detail_job_config', only: [:index, :update]
  end

  resources :sales_reps, only: :show do
    get :analytics
  end

  resources :vehicles do
    get :show_map
    get :show_info_modal
    get :print_hold_tag
    get :print_service_hold_tag
    collection do
      get :inventory_count
      get :new_vehicle_groupings
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
    get :print_sold_sheet
    collection do
      put :stock_number_search
    end
  end
end
