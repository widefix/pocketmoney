# frozen_string_literal: true

class GetUserFromOmniauthAction < ApplicationAction
  option :access_token

  private

  def perform_implementation
    data = access_token.info
    user = User.find_by(email: data['email'])

    ActiveRecord::Base.transaction do
      if user.nil?
        user = create_user(data)
        user.create_account!(name: user.name, email: user.email)
      end
    end

    user
  end

  def create_user(data)
    User.create!(
      name: data['name'] || data['nickname'],
      email: data['email'],
      avatar_url: data['image'],
      password: Devise.friendly_token[0, 20],
      provider: access_token.provider
    )
  end

  def create_account_for(user)
    user.create_account!(name: user.name, email: user.email)
  end
end
