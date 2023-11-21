# frozen_string_literal: true

class AddParrentsKeyToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :parents_key, :integer
    add_index :users, :parents_key, unique: true
    add_column :users, :blocked_at, :datetime
  end
end
