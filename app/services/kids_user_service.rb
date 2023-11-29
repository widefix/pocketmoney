# frozen_string_literal: true

class KidsUserService
  extend Memoist

  def initialize(share)
    @share = share
  end

  def perform
    user = User.includes(:account).find_by(parental_key: parental_key)

    return user if user

    create_user
  end

  private

  def create_user
    ActiveRecord::Base.transaction do
      user = User.create(email: email, password: parental_key, parental_key: parental_key)
      user.create_account(name: email, email: email)
      user
    end
  end

  memoize def email
    "#{parental_key}@budgetingkid.com"
  end

  memoize def parental_key
    @share.parental_key
  end
end
