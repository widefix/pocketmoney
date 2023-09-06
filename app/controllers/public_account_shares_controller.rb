# frozen_string_literal: true

class PublicAccountSharesController < ApplicationController
  before_action :authenticate_user!

  def new; end

  def create
    AccountShare.create!(user_id: current_user.id, account_id: account.id, accepted_at: Time.current)
    redirect_to account_shares_path account
  end
end
