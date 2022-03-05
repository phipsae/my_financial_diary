class RealEstate < ApplicationRecord
  belongs_to :asset

  validates :sqm, :price_per_sqm, :mortgage, presence: true
end
