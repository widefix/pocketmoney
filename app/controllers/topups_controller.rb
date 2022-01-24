class TopupsController < ApplicationController
  def new
  end

  def create
    Transaction.create!(
      from_account: current_user.account,
      to_account: account,
      amount: ps.fetch(:amount)
    )
    redirect_to account_path(account)
  end

  private

  helper_method memoize def account
    Account.find(ps.fetch(:account_id))
  end
end
