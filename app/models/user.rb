# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  belongs_to :account, optional: true
  has_many :feedbacks

  validates :name, allow_blank: true, length: { minimum: 2, maximum: 20 }
end
