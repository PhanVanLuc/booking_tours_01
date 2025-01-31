Rails.application.routes.draw do
  devise_for :users,
              controllers: {omniauth_callbacks: "users/omniauth_callbacks"}
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    root 'static_pages#home'
    get "/food",   to: "static_pages#reviewfood"
    get "/place",   to: "static_pages#reviewplace"
    get "/signup",    to: "users#new"
    get "/login",     to: "sessions#new"
    post "/login",    to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    get "/tour",      to: "tours#tour"
    resources :users
  end
end

