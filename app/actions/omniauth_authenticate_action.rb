# frozen_string_literal: true

class OmniauthAuthenticateAction < ApplicationAction
  option :access_token

  private

  def perform_implementation
    existing_user || create_user
  end

  def existing_user
    User.find_by(email: access_token.info[:email])
  end

  def create_user
    data = access_token.info
    ActiveRecord::Base.transaction do
      user = User.create!(
        name: data[:name] || data[:nickname],
        email: data[:email],
        avatar_url: data[:image],
        password: Devise.friendly_token[0, 20],
        provider: access_token.provider
      )
      create_account_for(user)

      user
    end
  end

  def create_account_for(user)
    user.create_account!(name: user.name, email: user.email)
  end
end
