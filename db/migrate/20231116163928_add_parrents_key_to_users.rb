# frozen_string_literal: true

class AddParrentsKeyToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :parents_key, :integer
  end
end
