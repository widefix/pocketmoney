# frozen_string_literal: true

class PublicAccountSharesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :new]

  def show; end

  def new; end

  def create
    AccountShare.create!(user_id: current_user.id,
                         account_id: account.id,
                         token: SecureRandom.urlsafe_base64(32),
                         accepted_at: Time.current)
    redirect_to account_shares_path(account)
  end

  private

  helper_method memoize def public_account
    AccountShare.find_by(token: params[:token]).account
  end
end
