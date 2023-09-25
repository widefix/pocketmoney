# frozen_string_literal: true

class AccountShare < ApplicationRecord
  belongs_to :user
  belongs_to :account

  scope :for, ->(user) { where(email: user.email) }
  scope :accepted, -> { where.not(accepted_at: nil) }
  scope :unaccepted, -> { where(accepted_at: nil) }
  scope :active, -> { includes(:account).where(accounts: { archived_at: nil }) }

  memoize def public?
    email.nil? && name.nil?
  end
end
