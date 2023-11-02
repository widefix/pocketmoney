# frozen_string_literal: true

class SendNotification
  def initialize(account)
    @account = account
  end

  def self.call(...)
    new(...).execute
  end

  def execute
    TransactionsMailer.transaction_notification(@account, recipients&.uniq).deliver
  end

  private

  def recipients
    result = []
    result << @account.email if @account.notification?
    result += parent_emails if @account.notice_to_parents?
    result
  end

  def parent_emails
    [*@account.account_shares.accepted.pluck(:email), @account.parent.user.email]
  end
end
