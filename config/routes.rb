Rails.application.routes.draw do
  root "videos#index"

  get "search", to: "videos#search"

  resources :videos do
    resources :comments
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
