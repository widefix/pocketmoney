# frozen_string_literal: true

class Objective < ApplicationRecord
  belongs_to :account

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :name, presence: true

  scope :not_archived, -> { joins(:account).where(account: { archived_at: nil }) }

  def weeks_to_achieve
    return -1 if account.balance >= amount

    return 0 if account.automatic_topup_configs.blank?

    ([amount - account.balance, 0].max / account.automatic_topup_configs.sum(:amount).+(0.1)).ceil
  end
end
