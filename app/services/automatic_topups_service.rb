# frozen_string_literal: true

class AutomaticTopupsService
  def perform
    AccountAutomaticTopupConfig.visible.find_each do |config|
      AutomaticTopupAction.new(
        from: config.from_account,
        to: config.to_account,
        amount: config.amount
      ).perform
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error(e)
    end
  end
end
