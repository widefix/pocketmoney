# frozen_string_literal: true

class AddNotifyParentsForAccount < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :notify_parents, :boolean, default: true
  end
end
