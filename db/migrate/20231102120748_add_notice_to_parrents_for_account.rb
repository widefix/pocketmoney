# frozen_string_literal: true

class AddNoticeToParrentsForAccount < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :notice_to_parents, :boolean, default: true
  end
end
