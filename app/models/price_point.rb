class PricePoint < ApplicationRecord
  belongs_to :asset

  validates :cents, :date, presence: true
end
