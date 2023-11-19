Rails.application.routes.draw do
  root "videos#index"
  get "search", to: "videos#search"

  resources :videos do
    resources :comments
  end

  resource :registration
  resource :session
  resource :password
  resource :password_reset
end
