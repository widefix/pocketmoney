# frozen_string_literal: true

class AddAccumulativeBalanceTimeframeForAccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :accumulative_balance_timeframe, :string, default: 'by day'
  end
end
