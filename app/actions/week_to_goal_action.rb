# frozen_string_literal: true

class WeekToGoalAction
  def calculate(objective)
    return 999 if objective.account.automatic_topup_configs.blank?

    ([objective.amount - objective.account.balance, 0].max / objective.account.automatic_topup_configs.sum(:amount))
      .to_i
  end
end
