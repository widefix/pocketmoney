# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  belongs_to :account, optional: true
  has_many :feedbacks
  has_one_attached :avatar

  def active_for_authentication?
    super && user_active?
  end

  def user_active?
    blocked_at.nil?
  end

  memoize def parent?
    parental_key.nil?
  end
end
