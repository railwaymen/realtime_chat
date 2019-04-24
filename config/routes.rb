Rails.application.routes.draw do
  devise_for :users
  
  resources :room_messages
  resources :rooms
  
  namespace :api do
    namespace :v1 do
      resources :rooms, only: %i[index show create update destroy]
      resources :authentications, only: [:create] do
        post :refresh, on: :collection
      end
      resources :docs, only: %i[index]
    end
  end
  
  root controller: :rooms, action: :index
end
