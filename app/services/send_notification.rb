# frozen_string_literal: true

class SendNotification
  def initialize(account)
    @account = account
  end

  def self.call(...)
    new(...).execute
  end

  def execute
    return unless @account.notification? && @account.email.present?

    TransactionsMailer.transaction_notification(@account).deliver
    @account.account_shares.accepted.each do |account_share|
      TransactionsMailer.transaction_notification(@account, account_share).deliver
    end
  end
end
