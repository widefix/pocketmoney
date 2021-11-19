class Transaction < ApplicationRecord
  validates :amount, presence: true, numericality: { greater_than: 0 }

  belongs_to :to_account, class_name: 'Account', foreign_key: :to_account_id
  belongs_to :from_account, class_name: 'Account', foreign_key: :from_account_id

  def to_s
    "#{date} #{from_account.name} -> #{to_account.name}: #{amount}"
  end

  def date
    created_at.to_date
  end
end
