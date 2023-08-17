class AccountInvitation < ApplicationRecord
  belongs_to :user
  belongs_to :account

  enum status: { new: 0, accepted: 1 }
end
