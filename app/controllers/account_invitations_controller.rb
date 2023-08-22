class AccountInvitationsController < ApplicationController
  before_action :authenticate_user!

  def index; end

  def new; end

  def create
    AccountInvitation.create!(user_id: current_user.id, account_id: account.id, **account_invitation_params)
    redirect_to account_invitations_path account
  end

  def destroy
    invitation = AccountInvitation.find(ps.fetch(:id))
    invitation.destroy
    respond_to do |format|
      format.html { redirect_to account_invitations_url, notice: 'Account invitation was successfully destroyed.' }
    end
  end

  private

  def account_invitation_params
    params.require(:account_invitation).permit(:name, :email)
  end
end
