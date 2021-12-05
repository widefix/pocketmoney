class SpendsController < ApplicationController
  def new
  end

  def create
    Transaction.create!(
      from_account: account,
      to_account: Account.find_or_create_by!(name: 'store'),
      amount: ps.fetch(:amount)
    )
    redirect_to account_path(account)
  end

  private

  helper_method memoize def account
    Account.find(ps.fetch(:account_id))
  end
end
