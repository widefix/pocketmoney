# frozen_string_literal: true

class AddAccomplishedAtToObjectives < ActiveRecord::Migration[6.1]
  def change
    add_column :objectives, :accomplished_at, :datetime
  end
end
