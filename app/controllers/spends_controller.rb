class SpendsController < ApplicationController
  def new
  end

  def create
    Transaction.create!(
      from_account: account,
      to_account: Account.find_or_create_by!(name: 'store'),
      description: params[:description],
      amount: ps.fetch(:amount),
      originator: current_user,
      access_token: Devise.friendly_token
    )
    send_notification

    redirect_to account_path(account)
  end

  def send_notification
    return unless account.notification?

    TransactionsMailer.transaction_notification(account).deliver
    account.account_shares.accepted.each do |account_share|
      TransactionsMailer.transaction_notification(account, account_share).deliver
    end
  end
end
