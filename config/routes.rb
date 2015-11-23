Rails.application.routes.draw do
  # resources :tweets, only: [:create, :new, :show]
  resources :tweets, only: [:create, :new]
  post 'tweets/show'
  root 'tweets#new'
end
