# frozen_string_literal: true

class AccountAutomaticTopupConfig < ApplicationRecord
  belongs_to :from_account, class_name: 'Account', foreign_key: :from_account_id
  belongs_to :to_account, class_name: 'Account', foreign_key: :to_account_id

  validates :amount, numericality: { greater_than: 0 }

  scope :visible, -> { joins(:to_account).where(to_account: { archived_at: nil }) }
end
