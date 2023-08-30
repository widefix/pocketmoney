# frozen_string_literal: true

class AccountShareMailer < ApplicationMailer
  def account_share(account_share)
    @account_share = account_share

    mail to: account_share.email, subject: 'Share to manage an account!'
  end
end
