Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'home#index'

  resource :my_account, only: :show

  resources :accounts, only: %i[show new create edit update] do
    resources :account_automatic_topup_configs, only: %i[new create]
    resource :topup, only: %i[new create]
    resource :spend, only: %i[new create]
    resources :objectives, only: %i[new create]
    resources :invitations, only: %i[index new create destroy], controller: 'account_invitations'
  end

  get 'account_invitation/:invitation_id', to: 'account_invitations#accept_invitation', as: :visit_by_account_invitation
  post 'account_invitation/:invitation_id', to: 'account_invitations#accept', as: :accept_account_invitation

  resources :transactions, only: [:destroy]
  resources :objectives, only: [:destroy]
end
