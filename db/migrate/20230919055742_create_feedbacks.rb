# frozen_string_literal: true

class CreateFeedbacks < ActiveRecord::Migration[6.1]
  def change
    create_table :feedbacks do |t|
      t.references :user, null: false, foreign_key: true
      t.string :description

      t.timestamps
    end
  end
end
