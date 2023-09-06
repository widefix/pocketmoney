# frozen_string_literal: true

class PublicAccountSharesController < ApplicationController
  before_action :authenticate_user!

  def new; end

  def create
    AccountShare.create!(user_id: current_user.id, account_id: account.id, accepted_at: Time.current)
    redirect_to account_shares_path account
  end

  def destroy
    public_account_share = AccountShare.find(ps.fetch(:id))
    public_account_share.destroy
    respond_to do |format|
      format.html { redirect_to account_shares_url, notice: 'Account share was successfully destroyed.' }
    end
  end
end
