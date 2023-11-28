# frozen_string_literal: true

class KidAccountSharesController < ApplicationController
  before_action :authenticate_user!

  def new; end

  def create
    parental_key = generate_unique_key
    AccountShare.create!(user_id: current_user.id,
                         account_id: account.id,
                         token: SecureRandom.urlsafe_base64(32),
                         accepted_at: Time.current,
                         name: account.name,
                         email: email(parental_key),
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

  def email(key)
    account.email.blank? ? "#{key}@budgetingkid.com" : account.email
  end
end
