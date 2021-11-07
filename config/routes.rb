Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'home#index'

  resource :my_account, only: :show

  resources :accounts, only: [:show, :new, :create] do
    resource :topup, only: [:new, :create]
    resource :spend, only: [:new, :create]
  end
  resources :transactions, only: [:destroy]
end
