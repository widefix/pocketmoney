class SpendsController < ApplicationController
  def create
    Transaction.create!(
      from_account: account,
      to_account: Account.find_or_create_by!(name: 'store'),
      description: params[:description],
      amount: ps.fetch(:amount),
      originator: current_user,
      access_token: Devise.friendly_token
    )
    SendNotification.call(account)

    redirect_to request.referrer
  end
end
