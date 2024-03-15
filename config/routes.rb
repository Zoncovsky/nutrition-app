# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  devise_for :admins
  
  namespace :admin do
    resources :orders
    resources :products do
      resources :stocks
    end
    resources :categories
  end
  
  authenticated :admin_user do
    root to: 'admin#index', as: :admin_root
  end
  
  resources :reviews, except: [:index, :show]
  resources :categories, only: [:show]
  resources :products, only: [:show]
  
  root 'home#index'
  get 'catalog' => 'shop#catalog'
  get 'admin/index'
  get 'admin' => 'admin#index'
  get 'category' => 'category#index'
  get 'cart' => 'carts#show'
  post 'checkout' => 'checkouts#create'
  get 'success' => 'checkouts#success'
  get 'cancel' => 'checkouts#cancel'
  post 'webhooks' => 'webhooks#stripe'
end
