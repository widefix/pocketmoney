# frozen_string_literal: true

class UpdateAccountService
  def initialize(account, params)
    @account = account
    @params = params
    @account_share = @account.account_shares.find_by.not(parental_key: nil)
    return unless @account_share

    @kid_user = User.includes(:account).find_by(parental_key: @account_share.parental_key)
    @kid_account = @kid_user.account
  end

  def perform
    return false if email_already_exists?(@params.email)

    ActiveRecord::Base.transaction do
      @account.update(@parems)
      models = [@account_share, @kid_user, @kid_account]
      models.each do |model|
        model&.update!(@params.slice(%i[email name]))
      end
    end
  end

  private

  def email_already_exists?(email)
    User.exists?(email: email).where.not(parental_key: @account_share.parental_key)
  end
end
