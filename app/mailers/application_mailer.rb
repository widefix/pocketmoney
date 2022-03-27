class ApplicationMailer < ActionMailer::Base
  default from: "\"Pocketmoney\" <no-reply@widefix.com>"
  layout 'mailer'

  private

  def prevent_delivery
    message.perform_deliveries = false
    true
  end
end
