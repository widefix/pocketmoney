# frozen_string_literal: true

class KidsUserService
  def initialize(share)
    @key = share.parental_key
    @account = share.account
    @name = @account.name
    @email = @account.email.blank? ? "#{@key}@budgetingkid.com" : @account.email
  end

  def perform
    user = User.includes(:account).find_by(parental_key: @key)

    return user if user

    create_user
  end

  private

  def create_user
    ActiveRecord::Base.transaction do
      user = User.create(email: @email, password: @key, parental_key: @key)
      user.create_account(name: @email, email: @email)
      user
    end
  end
end
