# frozen_string_literal: true

class InvitationMailer < ApplicationMailer
  def account_invitation(account_invitation)
    @account_invitation = account_invitation

    mail to: account_invitation.email, subject: 'Invitation to manage an account!'
  end
end
