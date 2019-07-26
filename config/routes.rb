# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  resources :attachments, only: %i[create destroy]

  resources :room_messages do
    get :load_more, on: :collection
  end

  resources :rooms do
    get :more, on: :collection
    put :join, on: :member
    post :update_activity, on: :member
  end

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :rooms, only: %i[index show create update destroy] do
        resources :messages, shallow: true
        resources :rooms_users, only: %i[index create destroy], shallow: true
        post :update_activity, on: :member
      end
      resources :authentications, only: [:create] do
        post :refresh, on: :collection
      end
      resources :docs, only: %i[index]
      resources :users, only: %i[index] do
        get :profile, on: :collection
      end
      resources :attachments, only: %i[create destroy]
    end
  end

  root controller: :rooms, action: :index
end
