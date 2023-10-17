# frozen_string_literal: true

class ObjectivesMailer < ApplicationMailer
  def objectives_achieved(objective, account_share = nil)
    @name = objective.account.name
    @user = objective.account.parent.user
    @balance = objective.account.balance
    @objective = objective.name
    prevent_delivery and return unless @user

    mail to: account_share&.email || @user.email, title: "Goal #{@objective} achived"
  end

  def objectives_almost_achieved(objective, account_share = nil)
    @name = objective.account.name
    @user = objective.account.parent.user
    @balance = objective.account.balance
    @objective = objective.name
    @amount = objective.amount

    mail to: account_share&.email || @user.email, title: "Goal #{@objective} almost achived"
  end
end
