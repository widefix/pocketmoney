# frozen_string_literal: true

class AcceptAccountInvitationsController < ApplicationController
  def show
    return if user_signed_in?

    session[:after_authentication_url] = request.fullpath

    invitee_email = AccountInvitation.find_by!(token: ps[:token]).email
    user = User.find_by(email: invitee_email)
    if user.present?
      redirect_to new_user_session_url(email: invitee_email)
    else
      redirect_to new_user_registration_url(email: invitee_email)
    end
  end

  def update
    received_invitation.update!(accepted_at: Time.current)
    redirect_to account_path(received_invitation.account_id)
  end

  private

  helper_method memoize def received_invitation
    AccountInvitation.unaccepted.for(current_user).find_by!(token: ps[:token])
  end
end
