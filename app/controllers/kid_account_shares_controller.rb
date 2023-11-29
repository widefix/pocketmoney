# frozen_string_literal: true

class KidAccountSharesController < ApplicationController
  before_action :authenticate_user!

  def new; end

  def create
    parental_key = generate_unique_key
    AccountShare.create!(user_id: current_user.id,
                         account_id: account.id,
                         accepted_at: Time.current,
                         name: account.name,
                         email: "#{parental_key}@budgetingkid.com",
                         parental_key: parental_key)
    redirect_to account_shares_path(account)
  end

  private

  def generate_unique_key
    loop do
      key = SecureRandom.hex(3)
      return key unless User.exists?(parental_key: key)
    end
  end
end
