# frozen_string_literal: true

class SendNotification
  def initialize(account)
    @account = account
  end

  def self.call(...)
    new(...).execute
  end

  def execute
    TransactionsMailer.transaction_notification(@account, recipients).deliver
  end

  private

  def recipients
    return if !@account.notification? && !@account.notice_to_parents?

    return [*parent_emails, @account.email] if @account.notification? && @account.notice_to_parents?
    return parent_emails if @account.notice_to_parents?

    [@account.email]
  end

  def parent_emails
    [*@account.account_shares.accepted.pluck(:email), @account.parent.user.email]
  end
end
