# frozen_string_literal: true

class Account < ApplicationRecord
  has_many :income_transactions, class_name: 'Transaction', foreign_key: :to_account_id
  has_many :outcome_transactions, class_name: 'Transaction', foreign_key: :from_account_id
  has_many :children, class_name: 'Account', foreign_key: :parent_id
  has_many :account_invitations

  # an account has user optionally
  has_one :user

  has_many :automatic_topup_configs, class_name: 'AccountAutomaticTopupConfig', foreign_key: :to_account_id
  has_many :objectives

  belongs_to :parent, class_name: 'Account', optional: true

  validates :name, presence: true

  scope :visible_for, lambda { |current_user|
    where(id: [current_user.account_id] +
               current_user.account.child_ids +
               invitees(current_user).pluck(:id))
  }

  scope :invitees, ->(user) { where(id: AccountInvitation.accepted.for(user).pluck(:account_id)) }

  memoize def balance
    income_transactions.sum(:amount) - outcome_transactions.sum(:amount)
  end

  def transactions
    Transaction.where(to_account: self).or(Transaction.where(from_account: self))
  end

  def accumulative_balance_data
    transactions_grouped_by_day = transactions.group_by { |t| t.created_at.to_date }
    balance = 0
    accumulative_balance_by_day = {}

    transactions_grouped_by_day.each do |date, transactions|
      balance += transactions.sum { |transaction| transaction.from_account_id == id ? -transaction.amount : transaction.amount }
      accumulative_balance_by_day[date] = balance
    end

    accumulative_balance_by_day
  end
end
