# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2, :facebook]

  belongs_to :account, optional: true
  has_many :feedbacks
  has_one_attached :avatar

  memoize def parent?
    parental_key.nil?
  end

  memoize def owner?(child_account)
    child_account.parent_id == account.id
  end
end
