class AccountAutomaticTopupConfig < ApplicationRecord
  belongs_to :from_account, class_name: 'Account', foreign_key: :from_account_id
  belongs_to :to_account, class_name: 'Account', foreign_key: :to_account_id

  scope :visible, -> { where(to_account: { archived_at: nil }) }
end
