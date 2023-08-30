# frozen_string_literal: true

class InvitationMailer < ApplicationMailer
  def account_invitation(account_invitation, current_user)
    @account_invitation = account_invitation
    @current_user = current_user
    mail to: account_invitation.email, subject: "Invitation to manage an account from #{@current_user.name || "#{@current_user.email} owner"}"
  end
end
