class TopupsController < ApplicationController
  def new
  end

  def create
    Transaction.create!(
      from_account: current_user.account,
      to_account: account,
      description: params[:description],
      amount: ps.fetch(:amount),
      originator: current_user,
      access_token: Devise.friendly_token
    )
    SendNotification.call(account)

    redirect_to account_path(account)
  end
end
