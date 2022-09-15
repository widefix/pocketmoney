class TopupsController < ApplicationController
  def new
  end

  def create

    Transaction.create!(
      from_account: current_user.account,
      to_account: account,
      description: params[:description],
      amount: ps.fetch(:amount)
    )

    if account.notification?
      TransactionsMailer.transaction_notification(account).deliver
    end
    
    redirect_to account_path(account)
  end
end
