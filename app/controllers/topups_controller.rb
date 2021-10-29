class TopupsController < ApplicationController
  def new
  end

  def create
    Transaction.create!(
      from_account: 'andrei',
      to_account: account,
      amount: params.fetch(:amount)
    )
    redirect_to account_path(account)
  end

  private

  helper_method memoize def account
    params.fetch(:account_id)
  end
end
