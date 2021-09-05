# config/routes.rb
require "sidekiq/web"
require "sidekiq/cron/web"

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"
  mount ActionCable.server => '/cable'
  
  devise_for :users,
              controllers: {omniauth_callbacks: "users/omniauth_callbacks"}
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    root "static_pages#home"
    get "/thanks",    to: "static_pages#thanks"
    get "/reviews/food",      to: "static_pages#reviewfood", as: "food"
    get "/reviews/place",      to: "static_pages#reviewplace", as: "place"
    get "/categories/by_parent",    to: "categories#by_parent"
    get "/notifications/read",    to: "notifications#read"
    get "/signup",    to: "users#new"
    get "/login",     to: "sessions#new"
    get "/success",   to: "checkout#success"
    get "/cancel",    to: "checkout#cancel"
    post "/login",    to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    resources :ratings
    resources :bookings
    resources :checkout, only: :create
    resources :billing,  only: :create
    resources :webhooks, only: :create
    resources :revenues, only: :index
    resources :tours
    resources :users
    resources :categories
    resources :comments do
      member do
        put :hidden
      end
    end
    resources :reviews do
      member do
        put :hidden
        put :like
      end
    end
    resources :reviews do
      resources :comments
    end
    resources :statistics
    namespace :admin do
      resources :users,  only: [:new, :create]
      resources :tours, only: :index
    end
  end
end
