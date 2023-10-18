# frozen_string_literal: true

class ChangeObjectiveFieldsToDates < ActiveRecord::Migration[6.1]
  def change
    remove_column :objectives, :goal_achieved_notified
    remove_column :objectives, :goal_almost_achieved_notified
    add_column :objectives, :goal_achieved_notified_to, :datetime, default: nil
    add_column :objectives, :goal_almost_achieved_notified_to, :datetime, default: nil
  end
end
