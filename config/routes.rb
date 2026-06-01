Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "store#index"
  get "store", to: "store#index"

  # Authentication
  get    "signup", to: "users#new"
  post   "signup", to: "users#create"
  get    "login",  to: "sessions#new"
  post   "login",  to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  resources :products, except: [ :index ] do
    resources :reviews, only: [ :create, :edit, :update, :destroy ]
  end

  resource :cart, only: [ :show, :destroy ]
  resources :line_items, only: [ :create, :update, :destroy ]

  resources :orders, only: [ :index, :show, :new, :create ]
end
