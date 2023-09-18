# frozen_string_literal: true

class AccountShareMailer < ApplicationMailer
  def account_share(account_share)
    @account_share = account_share

    mail to: account_share.email, subject: 'Get access to account'
  end
end
