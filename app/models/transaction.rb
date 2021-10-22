class Transaction < ApplicationRecord
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :to_account, presence: true
  validates :from_account, presence: true

  def to_s
    "#{from_account} -> #{to_account}: #{amount}"
  end
end
