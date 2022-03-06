class RealEstate < ApplicationRecord
  belongs_to :asset
  has_many :price_points # , through: :assets

  validates :sqm, :price_per_sqm, :mortgage, presence: true
end
