# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  resources :room_messages
  resources :rooms

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :rooms, only: %i[index show create update destroy] do
        resources :messages, shallow: true
        resources :rooms_users, only: %i[index create destroy], shallow: true
      end
      resources :authentications, only: [:create] do
        post :refresh, on: :collection
      end
      resources :docs, only: %i[index]
      resources :users, only: %i[index]
    end
  end

  root controller: :rooms, action: :index
end
