class SpendsController < ApplicationController
  def new
  end

  def create
    Transaction.create!(
      from_account: account,
      to_account: 'store',
      amount: params.fetch(:amount)
    )
    redirect_to account_path(account)
  end

  private

  helper_method memoize def account
    params.fetch(:account_id)
  end
end
