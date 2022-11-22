class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('SMTP_DEFAULT_FROM', "Andrei Kaleshka at Money <andrei.kaleshka@widefix.com>")
  layout 'mailer'

  private

  def prevent_delivery
    message.perform_deliveries = false
    true
  end
end
