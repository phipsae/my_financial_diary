class Asset < ApplicationRecord
  belongs_to :user
  belongs_to :asset_kind
  has_many :price_points, dependent: :destroy
  has_many :real_estates, dependent: :destroy

  validates :name, presence: true
end
