# frozen_string_literal: true

class ObjectiveNotificationService
  def perform
    Objective.visible.each do |objective|
      automatic_topup_amount = objective.account.automatic_topup_configs.sum(:amount)
      account_balance = objective.account.balance
      objective_amount = objective.amount
      total_weeks_left = ([objective_amount - account_balance, 0].max / automatic_topup_amount).to_i

      check_almost_achieved(objective, total_weeks_left)
      check_achieved(objective, account_balance, objective_amount)
    end
  end

  private

  def check_almost_achieved(objective, total_weeks_left)
    return if total_weeks_left > 1 || objective.goal_almost_achieved_notified

    ObjectivesMailer.objectives_almost_achieved(objective).deliver
    objective.account.account_shares.accepted.visible.each do |account_share|
      ObjectivesMailer.objectives_almost_achieved(objective, account_share).deliver
    end
    objective.update!(goal_almost_achieved_notified: true)
  end

  def check_achieved(objective, account_balance, objective_amount)
    return if account_balance < objective_amount || objective.goal_achieved_notified

    ObjectivesMailer.objectives_achieved(objective).deliver
    objective.account.account_shares.accepted.visible.each do |account_share|
      ObjectivesMailer.objectives_achieved(objective, account_share).deliver
    end
    objective.update!(goal_achieved_notified: true)
  end
end
