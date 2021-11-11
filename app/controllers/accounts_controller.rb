class AccountsController < ApplicationController
  def show
  end

  def new
  end

  def create
    Account.create!(parent: current_user.account, **params.slice(:name))
    redirect_to my_account_path
  end

  private

  helper_method memoize def account
    Account.visible_for(current_user).find(params.fetch(:id))
  end
end
