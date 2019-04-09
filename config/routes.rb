Rails.application.routes.draw do
  devise_for :users

  resources :users, only: %i[index]

  root to: 'users#index'
end
