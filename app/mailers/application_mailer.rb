class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  private

  def prevent_delivery
    message.perform_deliveries = false
    true
  end
end
