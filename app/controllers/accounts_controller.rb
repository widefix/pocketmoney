class AccountsController < ApplicationController
  def show
  end

  def new
  end

  def create
    Account.create!(parent: current_user.account, **params.permit(:name).slice(:name))
    redirect_to my_account_path
  end

  private

  helper_method memoize def account
    Account
      .where(id: [current_user.account_id] + current_user.account.children_ids)
      .find(params.fetch(:id))
  end
end
