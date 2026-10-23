# frozen_string_literal: true

# Notification emails must never break the action that triggered them: a failed
# SMTP delivery should not turn a saved top-up into a 500 (inviting a duplicate
# retry) or abort the automatic top-up batch. Deliver now, report failures.
module SafeDelivery
  def self.call(message)
    message.deliver_now
  rescue StandardError => e
    Rails.logger.error("[SafeDelivery] #{e.class}: #{e.message}")
    Rollbar.error(e)
    nil
  end
end
