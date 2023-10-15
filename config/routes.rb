Rails.application.routes.draw do
  resources :comments
  resources :photos
  devise_for :users

  # Defines the root path route ("/")
  root "photos#index"
end
