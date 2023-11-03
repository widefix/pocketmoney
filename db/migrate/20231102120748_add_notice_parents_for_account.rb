# frozen_string_literal: true

class AddNoticeParentsForAccount < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :notice_parents, :boolean, default: true
  end
end
