class AccountInvitation < ApplicationRecord
  belongs_to :user
  belongs_to :account

  scope :accepted_by, lambda { |current_user|
                        where(email: current_user.email).where.not(accepted_at: nil)
                      }
end
