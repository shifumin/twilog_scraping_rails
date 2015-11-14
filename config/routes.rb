Rails.application.routes.draw do
  resources :tweets, only: [:create, :new, :show]
  root 'tweets#new'
end
