class PricePoint < ApplicationRecord
  belongs_to :asset
  has_one :real_estate, through: :asset

  accepts_nested_attributes_for :real_estate
  validates :cents, :date, presence: true
end
