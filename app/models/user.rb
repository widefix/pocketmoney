class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :account, optional: true

  validates :name, allow_blank: true, length: { minimum: 2, maximum: 20 }
end
