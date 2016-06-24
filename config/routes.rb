Rails.application.routes.draw do



  resources :user_events
  devise_for :users, :skip => [:registrations]

  devise_scope :user do
    get    "sign-up",  to: "devise/registrations#new",    as: :new_user_registration
    post   "sign-up",  to: "devise/registrations#create", as: :user_registration
  end
  # You can have the root of your site routed with "root"
  root 'welcome#index'


  resources :registration_tables
  resources :registrations
  resources :users
  resources :scenarios
  get 'welcome/index'

  resources :events do
    resources :sessions do
      resources :tables
    end
  end
# The priority is based upon order of creation: first created -> highest priority.
# See how all your routes lay out with "rake routes".


end
