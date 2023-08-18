class AccountInvitationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @account_invitations = current_user.account_invitations
  end

  def new
    @account_invitation = AccountInvitation.new
  end

  def create
    AccountInvitation.create!(user_id: current_user.id, **account_invitation_params)
    redirect_to account_invitations_path
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

  helper_method memoize def current_user_accounts
    Account.visible_for(current_user)
  end
end
