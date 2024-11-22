Rails.application.routes.draw do
  get "guest_lists/index"
  root "home#user_home"

  get "home/user_home"

  get "login", to: "sessions#new_user", as: "new_user_session"
  post "login", to: "sessions#create_user", as: "user_sessions"
  delete "logout", to: "sessions#destroy_user", as: "logout"

  get "register/user", to: "registrations#new_user", as: "new_user_registration"
  post "user_registrations", to: "registrations#create_user", as: "user_registrations"

  get "user_home", to: "home#user_home", as: "user_home"



  resources :events do
    member do
      post "add_guest"  # Adds a guest to a specific event
    end
    resources :guest_lists
    resources :budgets
    resources :itineraries
    resources :gift_registries
    resources :notifications
  end

  resources :guests, only: [ :index ] do
    patch :update_attendance, on: :collection
  end

  resources :events do
    resources :guest_lists, only: [ :index ]
  end
end
