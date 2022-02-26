class Asset < ApplicationRecord
  belongs_to :user
  has_many :price_points, dependent: :destroy
  has_many :real_estates, dependent: :destroy

  enum category: {
    cash: 0,
    securities: 1,
    real_estate: 2,
    raw_materials: 3,
    crypto: 4,
    cars: 5,
    others: 6
  }

  enum securities: {
    bonds: 0,
    shares: 1,
    fonds: 2
  }

  validates :name, :category, :sub_category, presence: true
end
