class RealEstate < ApplicationRecord
  belongs_to :asset

  validates :address, :sqm, :price_per_sqm, :mortgage, presence: true
end
