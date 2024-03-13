# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :admin do
    resources :orders
    resources :products do
      resources :stocks
    end
    resources :categories
  end
  get 'admin/index'
  devise_for :admins
  root 'home#index'

  authenticated :admin_user do
    root to: 'admin#index', as: :admin_root
  end

  resources :categories, only: [:show]
  resources :products, only: [:show]

  get 'admin' => 'admin#index'
  get 'category' => 'category#index'
  get 'cart' => 'carts#show'
  post 'checkout' => 'checkouts#create'
  get 'success' => 'checkouts#success'
  get 'cancel' => 'checkouts#cancel'
  post 'webhooks' => 'webhooks#stripe'
end
