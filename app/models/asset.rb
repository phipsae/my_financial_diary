class Asset < ApplicationRecord
  belongs_to :user
  belongs_to :asset_kind
  has_many :price_points
  has_many :real_estates

  validates :name, presence: true
end
