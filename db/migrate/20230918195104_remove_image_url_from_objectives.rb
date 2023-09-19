# frozen_string_literal: true

class RemoveImageUrlFromObjectives < ActiveRecord::Migration[6.1]
  def change
    remove_column :objectives, :image_url, :string
  end
end
