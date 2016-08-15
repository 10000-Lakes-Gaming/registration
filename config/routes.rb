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
    resources :user_events
    resources :sessions do
      resources :tables do
        resources :registration_tables
        resources :game_masters
      end
    end
  end

  # message stuffs
  get 'contact', to: 'contact#new', as: 'contact'
  post 'contact', to: 'contact#create'
  resources :contact

  get 'session_reminder', to: 'session_reminder#new', as: 'session_reminder'
  post 'session_reminder', to: 'session_reminder#create'
  resources :session_reminder
# The priority is based upon order of creation: first created -> highest priority.
# See how all your routes lay out with "rake routes".
end
