# frozen_string_literal: true

class ObjectiveNotificationService
  def perform
    Objective.not_archived.each do |objective|
      check_almost_achieved(objective, WeekToGoalAction.new.calculate(objective))
      check_achieved(objective, objective.account.balance, objective.amount)
    end
  end

  private

  def check_almost_achieved(objective, total_weeks_left)
    return if total_weeks_left > 1 || total_weeks_left.zero? || objective.goal_almost_achieved_notified_to

    ObjectivesMailer.objectives_almost_achieved(objective).deliver
    objective.account.account_shares.accepted.each do |account_share|
      ObjectivesMailer.objectives_almost_achieved(objective, account_share).deliver
    end
    objective.update!(goal_almost_achieved_notified_to: Time.current)
  end

  def check_achieved(objective, account_balance, objective_amount)
    return if account_balance < objective_amount || objective.goal_achieved_notified_to

    ObjectivesMailer.objectives_achieved(objective).deliver
    objective.account.account_shares.accepted.each do |account_share|
      ObjectivesMailer.objectives_achieved(objective, account_share).deliver
    end
    objective.update!(goal_achieved_notified_to: Time.current)
  end
end
