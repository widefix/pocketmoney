class Transaction < ApplicationRecord
  validates :amount, presence: true, numericality: { greater_than: 0 }

  belongs_to :to_account, class_name: 'Account', foreign_key: :to_account_id
  belongs_to :from_account, class_name: 'Account', foreign_key: :from_account_id
  belongs_to :originator, class_name: 'User', foreign_key: :originator_id, optional: true

  def to_s
    "#{date} #{from_account.name} -> #{to_account.name}: #{amount}"
  end

  def date
    created_at.strftime('%b %d, %y')
  end

  def short_date
    created_at.strftime('%b %d')
  end

  def time
    created_at.strftime('%R %b %d, %y')
  end

  def signed_amount(account)
    sign = from_account == account ? '-' : '+'
    "#{sign}#{amount}"
  end
end
