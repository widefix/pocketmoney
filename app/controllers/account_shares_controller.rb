# frozen_string_literal: true

class AccountSharesController < ApplicationController
  before_action :authenticate_user!
  before_action :account_share, only: [:destroy]

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
    return unless accessible?

    account_share.destroy
    respond_to do |format|
      format.html { redirect_to account_shares_url, notice: 'Account share was successfully destroyed.' }
    end
  end

  private

  def account_share_params
    params.require(:account_share).permit(:name, :email)
  end

  memoize def account_share
    AccountShare.find(params.fetch(:id))
  end

  def accessible?
    current_user.id == account_share.user_id || current_user.email == account_share.email
  end
end
