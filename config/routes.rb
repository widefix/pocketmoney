# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'home#index'
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  resource :my_account, only: :show

  resource :wizard, only: [] do
    get 'new_account', on: :member
    post 'create_account', on: :member
    get 'new_automatic_topup', on: :member
    post 'create_automatic_topup', on: :member
    get 'new_objective', on: :member
    post 'create_objective', on: :member
    get 'new_share_account', on: :member
    post 'create_share_account', on: :member
  end

  resources :accounts, only: %i[show new create edit update] do
    resources :account_automatic_topup_configs, only: %i[new create edit update destroy]
    resource :topup, only: %i[new create]
    resource :spend, only: %i[new create]
    resources :objectives, only: %i[new create]
    resources :shares, only: %i[index new create destroy], controller: 'account_shares'
    resources :public_account_shares, only: %i[new create]
    resources :share_for_kids, only: %i[new create], controller: 'kid_account_shares'

    member do
      get 'archive', action: 'archive'
      patch 'update_timeframe', action: 'update_timeframe'
    end
  end

  resources :accept_account_shares, param: :token, only: %i[show update]
  resources :terminate_shared_account, only: %i[update]
  resources :transactions, only: [:show, :destroy]
  resources :objectives, only: [:destroy]
  resources :public_accounts, param: :token, only: :show, controller: 'public_account_shares'
  resources :feedbacks, only: [:new, :create]
  resources :sign_in_kids, only: %i[new create]
  resources :archived_accounts, only: %i[index] do
    member do
      get 'restore', action: 'restore'
    end
  end

  get '/policy', to: 'policy#show'
  get '/choose_role', to: 'choose_role#index'
end
