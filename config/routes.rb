Rails.application.routes.draw do

  get "/" => "homes#top", as: "top"
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :users, only: [:show, :edit, :update, :index] do
    member do
      get :following, :followers
    end
  end

  resources :posts do
    resources :comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
  end

  resources :relationships, only: [:create, :destroy]

  resources :notifications, only: [:index]
  delete "notifications" => "notifications#destroy_all", as: "user_notifications_destroy_all"

end
