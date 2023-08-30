# frozen_string_literal: true

class AccountSharesController < ApplicationController
  before_action :authenticate_user!

  def index; end

  def new; end

  def create
    personal_account_share = AccountShare.create!(user_id: current_user.id,
                                                  account_id: account.id,
                                                  token: SecureRandom.urlsafe_base64(32),
                                                  **account_share_params)
    AccountShareMailer.account_share(personal_account_share).deliver
    redirect_to account_shares_path account
  end

  def destroy
    personal_account_share = AccountShare.find(ps.fetch(:id))
    personal_account_share.destroy
    respond_to do |format|
      format.html { redirect_to account_shares_url, notice: 'Account share was successfully destroyed.' }
    end
  end

  private

  def account_share_params
    params.require(:account_share).permit(:name, :email)
  end
end
