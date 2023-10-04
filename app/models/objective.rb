class Objective < ApplicationRecord
  belongs_to :account

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :name, presence: true
end
