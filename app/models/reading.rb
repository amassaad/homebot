class Reading < ApplicationRecord
  validates :time, :amount, :cost, presence: true
  validates :time, uniqueness: true
end
