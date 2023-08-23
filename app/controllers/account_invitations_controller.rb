class AccountInvitationsController < ApplicationController
  before_action :authenticate_user!, except: :accept_invitation

  def index; end

  def new; end

  def create
    AccountInvitation.create!(user_id: current_user.id,
                              account_id: account.id,
                              token: SecureRandom.urlsafe_base64(16),
                              **account_invitation_params)
    redirect_to account_invitations_path account
  end

  def destroy
    invitation = AccountInvitation.find(ps.fetch(:id))
    invitation.destroy
    respond_to do |format|
      format.html { redirect_to account_invitations_url, notice: 'Account invitation was successfully destroyed.' }
    end
  end

  def accept_invitation
    if params.key?(:invitation_id)
      redirect_to root_path unless received_invitation && token_valid? && invitation_belongs_to_current_user?
    else
      redirect_to root_path
    end
  end

  def accept
    received_invitation.update!(accepted_at: Time.now)
    redirect_to account_path received_invitation.account_id
  end

  private

  helper_method memoize def received_invitation
    AccountInvitation.find(ps.fetch(:invitation_id))
  end

  def invitation_belongs_to_current_user?
    current_user&.email == received_invitation.email
  end

  def token_valid?
    received_invitation.token == ps.fetch(:token)
  end

  def account_invitation_params
    params.require(:account_invitation).permit(:name, :email)
  end
end
