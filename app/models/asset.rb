class Asset < ApplicationRecord
  belongs_to :user
  has_many :price_points, dependent: :destroy
  has_many :real_estates, dependent: :destroy

   accepts_nested_attributes_for :price_points

  enum category: {
    cash: 0,
    securities: 1,
    real_estate: 2,
    raw_materials: 3,
    crypto: 4,
    cars: 5,
    others: 6
  }

  # enum sub_category: {
  #   cash: 0,
  #   shares: 1,
  #   fonds: 2,
  #   bonds: 3,
  #   house: 4,
  #   flat: 5,
  #   gold: 6,
  #   silver: 7,
  #   btc: 8,
  #   eth: 9,
  #   dot: 10,
  #   car: 11,
  #   other: 12
  # }

  validates :name, :category, :sub_category, presence: true
end
