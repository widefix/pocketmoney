Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'home#index'

  resources :accounts, only: :show do
    resource :topup, only: [:new, :create]
    resource :spend, only: [:new, :create]
  end
  resources :transactions, only: [:destroy]
end
