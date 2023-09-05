Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'home#index'
  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }
  resource :my_account, only: :show

  resources :accounts, only: %i[show new create edit update] do
    resources :account_automatic_topup_configs, only: %i[new create edit update destroy]
    resource :topup, only: %i[new create]
    resource :spend, only: %i[new create]
    resources :objectives, only: %i[new create]
    resources :shares, only: %i[index new create destroy], controller: 'account_shares'
    resources :public_account_shares, only: %i[new create destroy]
  end

  resources :accept_account_shares, param: :token, only: %i[show update]
  resources :transactions, only: [:destroy]
  resources :objectives, only: [:destroy]
end
