# frozen_string_literal: true

class AddForKidToAccountShares < ActiveRecord::Migration[6.1]
  def change
    add_column :account_shares, :for_kid, :boolean, default: false
  end
end
