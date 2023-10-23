# frozen_string_literal: true

class Account < ApplicationRecord
  has_many :income_transactions, class_name: 'Transaction', foreign_key: :to_account_id
  has_many :outcome_transactions, class_name: 'Transaction', foreign_key: :from_account_id
  has_many :children, class_name: 'Account', foreign_key: :parent_id
  has_many :account_shares

  # an account has user optionally
  has_one :user
  has_many :automatic_topup_configs, class_name: 'AccountAutomaticTopupConfig', foreign_key: :to_account_id
  has_many :objectives
  belongs_to :parent, class_name: 'Account', optional: true
  has_one_attached :avatar

  validates :name, presence: true
  validates :email, presence: true, if: :notification?

  scope :unarchived, -> { where(archived_at: nil) }
  scope :archived, -> { where.not(archived_at: nil) }

  scope :visible_for, lambda { |current_user|
    where(id: [current_user.account_id] +
               current_user.account.child_ids +
               shared_for(current_user).pluck(:id))
  }

  scope :visible_for_owner, lambda { |current_user|
    where(id: [current_user.account_id] + current_user.account.child_ids)
  }

  scope :shared_for, ->(user) { where(id: AccountShare.accepted.for(user).pluck(:account_id)) }

  memoize def balance
    income_transactions.sum(:amount) - outcome_transactions.sum(:amount)
  end

  def transactions
    Transaction.where(to_account: self).or(Transaction.where(from_account: self)).order(created_at: :desc)
  end

  def accumulative_balance_data
    result = ActiveRecord::Base.connection.execute(balance_sql)
    result.to_h { |transaction| [transaction['date'], transaction['sum']] }
  end

  private

  def balance_sql
    <<-SQL
      WITH trs AS (
        SELECT
          id,
          created_at::date AS date,
          CASE WHEN to_account_id = #{id} THEN amount ELSE -amount END AS amount
        FROM transactions
        WHERE to_account_id = #{id} OR from_account_id = #{id}
        ORDER BY created_at::date
      )
      SELECT date, SUM(amount) OVER (ORDER BY date)
      FROM trs
      ORDER BY date;
    SQL
  end
end
