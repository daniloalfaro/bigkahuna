# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users
      resources :movies do
        member do
          get :availability
          get :buy
          get :rent
          get :return
        end
      end
      post 'user_token' => 'user_token#create'
      post 'find_user' => 'users#find'
    end
  end
end
