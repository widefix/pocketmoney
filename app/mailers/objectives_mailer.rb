# frozen_string_literal: true

class ObjectivesMailer < ApplicationMailer
  def goal_achieved(objective, emails)
    @account = objective.account
    @objective = objective.name

    mail to: emails, title: "Goal #{@objective} achived"
  end

  def goal_almost_achieved(objective, emails)
    @account = objective.account
    @objective = objective.name
    @amount = objective.amount

    mail to: emails, title: "Goal #{@objective} almost achived"
  end
end
