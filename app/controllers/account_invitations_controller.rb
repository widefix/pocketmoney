class AccountInvitationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @account_invitations = account.invitations
  end

  def new
    @account_invitation = AccountInvitation.new
  end

  def create
    AccountInvitation.create!(user_id: current_user.id, account_id: ps.fetch(:account_id), **account_invitation_params)
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
    params.require(:account_invitation).permit(:name, :email, :account_id)
  end
end
