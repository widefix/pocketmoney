# frozen_string_literal: true

class KidAccountSharesController < ApplicationController
  before_action :authenticate_user!

  def new; end

  def create
    account.update(parents_key: generate_unique_key)
    AccountShare.create!(user_id: current_user.id,
                         account_id: account.id,
                         token: SecureRandom.urlsafe_base64(32),
                         accepted_at: Time.current,
                         for_kid: true)
    redirect_to account_shares_path(account)
  end

  private

  def generate_unique_key
    loop do
      key = format('%06d', SecureRandom.random_number(1_000_000))
      return key unless Account.exists?(parents_key: key)
    end
  end
end
