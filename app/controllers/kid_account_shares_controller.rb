# frozen_string_literal: true

class KidAccountSharesController < ApplicationController
  before_action :authenticate_user!

  def new; end

  def create
    parents_key = generate_unique_key
    account.update(parents_key: parents_key)
    email = "#{parents_key}@budgetingkid.com"
    user = User.create!(email: email, password: parents_key)
    user.create_account(name: account.name, email: email)
    AccountShare.create!(user_id: current_user.id,
                         account_id: account.id,
                         token: SecureRandom.urlsafe_base64(32),
                         accepted_at: Time.current,
                         email: email,
                         for_kid: true)
    redirect_to account_shares_path(account)
  end

  def destroy
    account_share = AccountShare.find(params.fetch(:id))
    account = Account.find_by(email: account_share.email)
    user = account.user
    account_share.destroy
    user.destroy
    account.destroy
    respond_to do |format|
      format.html { redirect_to account_shares_url, notice: 'Account share was successfully destroyed.' }
    end
  end

  private

  def generate_unique_key
    loop do
      key = format('%06d', SecureRandom.random_number(1_000_000))
      return key unless Account.exists?(parents_key: key)
    end
  end
end
