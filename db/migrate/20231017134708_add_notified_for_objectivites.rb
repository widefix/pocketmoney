# frozen_string_literal: true

class AddNotifiedForObjectivites < ActiveRecord::Migration[6.1]
  def change
    add_column :objectives, :goal_achieved_notified_at, :datetime
    add_column :objectives, :goal_almost_achieved_notified_at, :datetime
  end
end
