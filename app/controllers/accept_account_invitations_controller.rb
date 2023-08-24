# frozen_string_literal: true

class AcceptAccountInvitationsController < ApplicationController
  before_action :authenticate_user!

  def show
    received_invitation
  end

  def update
    received_invitation.update!(accepted_at: Time.current)
    redirect_to account_path(received_invitation.account_id)
  end

  private

  helper_method memoize def received_invitation
    AccountInvitation.unaccepted_for(current_user).find_by!(token: ps.fetch(:token))
  end
end
