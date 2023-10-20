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
    return if !goal_almost_achieved?(objective) || objective.goal_almost_achieved_notified_at

    ObjectivesMailer.goal_almost_achieved(objective, recipients(objective)).deliver
    objective.update!(goal_almost_achieved_notified_at: Time.current)
  end

  def send_achieved_notification(objective)
    return if !goal_achieved?(objective) || objective.goal_achieved_notified_at

    ObjectivesMailer.goal_achieved(objective, recipients(objective)).deliver
    objective.update!(goal_achieved_notified_at: Time.current)
  end

  def recipients(objective)
    [*objective.account.account_shares.accepted.pluck(:email), objective.account.parent.user.email]
  end

  def goal_almost_achieved?(objective)
    objective.week_to_achieved == 1
  end

  def goal_achieved?(objective)
    objective.week_to_achieved == -1
  end
end
