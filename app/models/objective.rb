class Objective < ApplicationRecord
  belongs_to :account

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :name, presence: true

  scope :not_archived, -> { joins(:account).where(account: { archived_at: nil }) }
end
