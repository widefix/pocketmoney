# frozen_string_literal: true

class ObjectiveNotificationService
  def initialize(account)
    @account = account
  end

  def perform
    Objective.not_archived.not_accomplished.for(@account).each do |objective|
      send_almost_achieved_notification(objective)
      send_achieved_notification(objective)
    end
  end

  private

  def send_almost_achieved_notification(objective)
    return if !goal_almost_achieved?(objective) || objective.goal_almost_achieved_notified_at

    ObjectivesMailer.goal_almost_achieved(objective, recipients).deliver
    objective.update!(goal_almost_achieved_notified_at: Time.current)
  end

  def send_achieved_notification(objective)
    return if !goal_achieved?(objective) || objective.goal_achieved_notified_at

    ObjectivesMailer.goal_achieved(objective, recipients).deliver
    objective.update!(goal_achieved_notified_at: Time.current)
  end

  def recipients
    [*@account.account_shares.accepted.pluck(:email), @account.parent.user.email]
  end

  def goal_almost_achieved?(objective)
    objective.weeks_to_achieve == 1
  end

  def goal_achieved?(objective)
    objective.weeks_to_achieve == -1
  end
end
