# frozen_string_literal: true

class KidAccountSharesController < ApplicationController
  before_action :authenticate_user!

  def new; end

  def create
    parents_key = generate_unique_key
    user = User.includes(:account).find_by(parents_key: account.parents_key) if account.parents_key?
    user ? unblock_user(user, parents_key) : create_user(parents_key)
    account.update(parents_key: parents_key)
    create_share(email(parents_key))

    redirect_to account_shares_path(account)
  end

  def destroy
    AccountShare.find(params.fetch(:id)).destroy
    User.find_by(parents_key: params.fetch(:parents_key)).update(blocked_at: Time.current)
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

  memoize def email(parents_key)
    account.email.blank? ? "#{parents_key}@budgetingkid.com" : account.email
  end

  def unblock_user(user, parents_key)
    user.update(email: email(parents_key), password: parents_key, parents_key: parents_key, blocked_at: nil)
    user.account.update(name: account.name, email: email(parents_key))
  end

  def create_user(parents_key)
    user = User.create(email: email(parents_key), password: parents_key, parents_key: parents_key)
    user.create_account(name: account.name, email: email(parents_key))
  end

  def create_share(email)
    AccountShare.create!(user_id: current_user.id,
                         account_id: account.id,
                         token: SecureRandom.urlsafe_base64(32),
                         accepted_at: Time.current,
                         email: email,
                         for_kid: true)
  end
end
