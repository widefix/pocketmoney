# frozen_string_literal: true

class ObjectiveNotificationService
  def perform
    Objective.not_archived.each do |objective|
      send_almost_achieved_notification(objective)
      send_achieved_notification(objective)
    end
  end

  private

  def send_almost_achieved_notification(objective)
    return if !goal_almost_achived?(objective) || objective.goal_almost_achieved_notified_at

    ObjectivesMailer.goal_almost_achieved(objective, emails(objective)).deliver
    objective.update!(goal_almost_achieved_notified_at: Time.current)
  end

  def send_achieved_notification(objective)
    return if !goal_achived?(objective) || objective.goal_achieved_notified_at

    ObjectivesMailer.goal_achieved(objective, emails(objective)).deliver
    objective.update!(goal_achieved_notified_at: Time.current)
  end

  def emails(objective)
    [objective.account.parent.user.email].concat(objective.account.account_shares.accepted.pluck(:email))
  end

  def goal_almost_achived?(objective)
    objective.calculate_week_to_achived == 1
  end

  def goal_achived?(objective)
    objective.account.balance >= objective.amount
  end
end
