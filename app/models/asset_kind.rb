class AssetKind < ApplicationRecord
  has_many :assets, dependent: :destroy

  enum category: {
    cash: 0,
    securities: 1,
    real_estate: 2,
    raw_materials: 3,
    crypto: 4,
    cars: 5,
    others: 6
  }

  validates :category, :sub_category, presence: true
end
