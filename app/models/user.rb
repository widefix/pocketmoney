class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :account_invitation, foreign_key: :user_id
  belongs_to :account, optional: true
end
