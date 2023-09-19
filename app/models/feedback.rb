# frozen_string_literal: true

class Feedback < ApplicationRecord
  belongs_to :user

  validates :description, presence: true, length: { maximum: 5000 }
end
