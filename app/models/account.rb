class Account < ApplicationRecord
  has_many :income_transactions, class_name: 'Transaction', foreign_key: :to_account_id
  has_many :outcome_transactions, class_name: 'Transaction', foreign_key: :from_account_id
  has_many :children, class_name: 'Account', foreign_key: :parent_id
  has_many :account_invitations, foreign_key: :account_id

  # an account has user optionally
  has_one :user

  has_many :automatic_topup_configs, class_name: 'AccountAutomaticTopupConfig', foreign_key: :to_account_id
  has_many :objectives

  belongs_to :parent, class_name: 'Account', optional: true

  validates :name, presence: true

  scope :visible_for, -> (current_user) {
    where(id: [current_user.account_id] + current_user.account.child_ids)
  }

  memoize def balance
    income_transactions.sum(:amount) - outcome_transactions.sum(:amount)
  end

  def transactions
    Transaction.where(to_account: self).or(Transaction.where(from_account: self))
  end
end
