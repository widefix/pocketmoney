class Objective < ApplicationRecord
  belongs_to :account

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :name, presence: true

  scope :not_archived, -> { joins(:account).where(account: { archived_at: nil }) }

  def calculate_week_to_achived
    return '' if account.automatic_topup_configs.blank?

    return 'Achived' if account.balance >= amount

    ([amount - account.balance, 0].max / account.automatic_topup_configs.sum(:amount).+(0.1)).ceil
  end
end
