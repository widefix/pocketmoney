class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :my_accounts_invitations, class_name: 'AccountInvitation'
  belongs_to :account, optional: true
end
