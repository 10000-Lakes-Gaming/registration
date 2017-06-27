Rails.application.routes.draw do

  devise_for :users
  # You can have the root of your site routed with "root"
  root 'welcome#index'


  resources :users
  resources :scenarios

  get 'welcome/index'
  get 'admin/index'
  resources :admin

  resources :events do
    resources :gm_list
    resources :table_assignment
    resources :user_events do
      resources :registration_payment, only: [:new, :create]
    end
    resources :sessions do
      resources :tables do
        resources :registration_tables
        resources :game_masters
      end
    end
    resources :session_reminder
    resources :payment_reminder
    resources :registration_reminder
    resources :attendee_email
  end


  # message stuffs
  get 'contact', to: 'contact#new', as: 'contact'
  post 'contact', to: 'contact#create'
  resources :contact

  get 'admin_email', to: 'admin_email#new', as: 'admin_email'
  post 'contact', to: 'admin_email#create'
  resources :admin_email

# The priority is based upon order of creation: first created -> highest priority.
# See how all your routes lay out with "rake routes".
end
