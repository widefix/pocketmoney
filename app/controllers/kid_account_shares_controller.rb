# frozen_string_literal: true

class KidAccountSharesController < ApplicationController
  before_action :authenticate_user!

  def new; end

  def create
    parental_key = generate_unique_key
    ActiveRecord::Base.transaction do
      user = User.includes(:account).find_by(parental_key: account.parental_key) if account.parental_key?
      user ? unblock_user(user, parental_key) : create_user(parental_key)
      account.update(parental_key: parental_key)
      create_share(email(parental_key), parental_key)
    end

    redirect_to account_shares_path(account)
  end

  def destroy
    ActiveRecord::Base.transaction do
      AccountShare.find(params.fetch(:id)).destroy
      User.find_by(parental_key: params.fetch(:parental_key)).update!(blocked_at: Time.current)
    end
    respond_to do |format|
      format.html { redirect_to account_shares_url, notice: 'Account share was successfully destroyed.' }
    end
  end

  private

  def generate_unique_key
    loop do
      key = SecureRandom.hex(3).upcase
      return key unless Account.exists?(parental_key: key)
    end
  end

  memoize def email(parental_key)
    account.email.blank? ? "#{parental_key}@budgetingkid.com" : account.email
  end

  def unblock_user(user, parental_key)
    user.update(email: email(parental_key), password: parental_key, parental_key: parental_key, blocked_at: nil)
    user.account.update(name: account.name, email: email(parental_key))
  end

  def create_user(parental_key)
    user = User.create(email: email(parental_key), password: parental_key, parental_key: parental_key)
    user.create_account(name: account.name, email: email(parental_key))
  end

  def create_share(email, parental_key)
    AccountShare.create!(user_id: current_user.id,
                         account_id: account.id,
                         token: SecureRandom.urlsafe_base64(32),
                         accepted_at: Time.current,
                         name: account.name,
                         email: email,
                         parental_key: parental_key)
  end
end
