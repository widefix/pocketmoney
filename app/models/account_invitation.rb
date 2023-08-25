class AccountInvitation < ApplicationRecord
  belongs_to :user
  belongs_to :account

  scope :for, ->(user) { where(email: user.email) }
  scope :accepted, -> { where.not(accepted_at: nil) }
  scope :unaccepted, -> { where(accepted_at: nil) }
end
