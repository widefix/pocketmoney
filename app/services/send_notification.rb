# frozen_string_literal: true

class SendNotification
  def initialize(account)
    @account = account
  end

  def self.call(...)
    new(...).execute
  end

  def execute
    SafeDelivery.call(TransactionsMailer.transaction_notification(@account, recipients))
  end

  private

  def recipients
    result = []
    result << @account.email if @account.notification?
    result += parent_emails if @account.notify_parents?
    result.uniq
  end

  def parent_emails
    [*@account.account_shares.accepted.for_parents.pluck(:email), @account.parent.user.email]
  end
end
