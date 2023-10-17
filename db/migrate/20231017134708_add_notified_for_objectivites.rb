# frozen_string_literal: true

class AddNotifiedForObjectivites < ActiveRecord::Migration[6.1]
  def change
    add_column :objectives, :goal_achieved_notified, :boolean, default: false
    add_column :objectives, :goal_almost_achieved_notified, :boolean, default: false
  end
end
