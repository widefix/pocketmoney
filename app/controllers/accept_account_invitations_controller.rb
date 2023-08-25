# frozen_string_literal: true

class AcceptAccountInvitationsController < ApplicationController
  def show
    return if user_signed_in? && the_invitation

    session[:token] = ps[:token]
    redirect_to new_user_session_url(email: the_invitation.email)
  end

  def update
    received_invitation.update!(accepted_at: Time.current)
  end

  private

  helper_method memoize def received_invitation
    AccountInvitation.unaccepted.for(current_user).find_by!(token: ps.fetch(:token))
  end

  memoize def the_invitation
    AccountInvitation.find_by!(token: ps.fetch(:token))
  end
end
