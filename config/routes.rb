# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  # You can have the root of your site routed with "root"
  root 'welcome#index'

  resources :users

  get 'sendPasswordReset', to: 'users#password_update', as: 'send_password_reset'

  resources :scenarios do
    get 'clone'
  end

  get 'welcome/index'
  get 'admin/index'
  resources :admin

  resources :events do
    member do
      get 'scenario_request_form', defaults: { format: :json }
    end
    resources :event_hosts
    resources :gm_list
    resources :gms_by_scenario
    resources :table_assignment
    resources :event_receipt
    resources :gm_list, only: :index
    resources :gms_by_scenario, only: :index
    resources :tables_by_session, only: :index
    resources :table_assignment, only: :index
    resources :tickets, only: :index

    resources :user_events do
      collection do
        get 'search'
        get 'show_since'
      end
      resources :additional_payments do
        resources :additional_payment_payment, only: %i[new create]
      end
      resources :registration_payment, only: %i[new create]
    end
    resources :sessions do
      resources :tables do
        resources :registration_tables do
          resources :table_payment, only: %i[new create]
        end
        resources :game_masters
      end
    end
  end

  post 'sessions/:session_id/upload_tables', to: 'tables#load_from_csv', as: 'upload_tables_csv'
  post 'scenarios/upload_scenarios', to: 'scenarios#load_from_csv', as: 'upload_scenarios_csv'

  get 'events/:id/additional_payment_report', to: 'additional_payment_report#index', as: 'additional_payment_report'

  # player emails for table
  # resources :table_player_email do
  get 'email_players/:table_id', to: 'table_player_email#new', as: 'email_players'
  post 'email_players/:table_id', to: 'table_player_email#create'
  # end

  # message stuffs
  get 'contact', to: 'contact#new', as: 'contact'
  post 'contact', to: 'contact#create'
  resources :contact

  get 'cotn_email', to: 'cotn_email#new', as: 'cotn_email'
  post 'cotn_email', to: 'cotn_email#create'
  resources :cotn_email

  get 'admin_email', to: 'admin_email#new', as: 'admin_email'
  post 'contact', to: 'admin_email#create'
  resources :admin_email

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
end
