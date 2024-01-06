# frozen_string_literal: true

class TopupsController < ApplicationController
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
    ObjectiveNotificationService.new(account).perform

    redirect_to request.referrer
  end
end
