# frozen_string_literal: true

class AcceptAccountInvitationsController < ApplicationController
  def show
    return if user_signed_in?

    session[:after_sign_in_url] = request.fullpath
    redirect_to new_user_session_url(email: AccountInvitation.find_by!(token: ps.fetch(:token)).email)
  end

  def update
    received_invitation.update!(accepted_at: Time.current)
    redirect_to account_path(received_invitation.account_id)
  end

  private

  helper_method memoize def received_invitation
    AccountInvitation.unaccepted.for(current_user).find_by!(token: ps.fetch(:token))
  end
end
