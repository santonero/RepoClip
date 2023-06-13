Rails.application.routes.draw do
  root "videos#index"
  get "search", to: "videos#search"

  resources :videos do
    resources :comments
  end
end
