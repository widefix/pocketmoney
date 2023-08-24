class AcceptAccountInvitationsController < ApplicationController
  def show
    not_found unless received_invitation &&
                     invitation_belongs_to_current_user? &&
                     not_accepted_invitation?
  end

  def update
    received_invitation.update!(accepted_at: Time.now)
    redirect_to account_path received_invitation.account_id
  end

  private

  helper_method memoize def received_invitation
    AccountInvitation.find_by(token: ps.fetch(:token))
  end

  def invitation_belongs_to_current_user?
    current_user&.email == received_invitation.email
  end

  def token_valid?
    received_invitation.token == ps.fetch(:token)
  end

  def not_accepted_invitation?
    received_invitation.accepted_at.nil?
  end
end
