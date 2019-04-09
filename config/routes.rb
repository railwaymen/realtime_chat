Rails.application.routes.draw do
  devise_for :users

  resources :users, only: %i[index]

  namespace :api do
    namespace :v1 do
      resources :authentications, only: [:create] do
        post :refresh, on: :collection
      end
      resources :docs, only: %i[index]
    end
  end

  root to: 'users#index'
end
