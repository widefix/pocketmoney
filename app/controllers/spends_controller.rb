class SpendsController < ApplicationController
  def new
  end

  def create
    Transaction.create!(
      from_account: account,
      to_account: Account.find_or_create_by!(name: 'store'),
      description: params[:description],
      amount: ps.fetch(:amount)
    )

    if account.notification?
      TransactionsMailer.transaction_notification(account).deliver
    end
    
    redirect_to account_path(account)
  end
end
