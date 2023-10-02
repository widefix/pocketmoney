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

  resources :accounts, only: %i[show new create edit update] do
    resources :account_automatic_topup_configs, only: %i[new create edit update destroy]
    resource :topup, only: %i[new create]
    resource :spend, only: %i[new create]
    resources :objectives, only: %i[new create]
    resources :shares, only: %i[index new create destroy], controller: 'account_shares'
    resources :public_account_shares, only: %i[new create]

    member do
      get 'archive', action: 'archive'
    end
  end

  resources :accept_account_shares, param: :token, only: %i[show update]
  resources :transactions, only: [:show, :destroy]
  resources :objectives, only: [:destroy]
  resources :public_accounts, param: :token, only: :show, controller: 'public_account_shares'
  resources :feedbacks, only: [:new, :create]
end
