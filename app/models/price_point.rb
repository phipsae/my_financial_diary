class PricePoint < ApplicationRecord
  belongs_to :asset
  has_one :real_estate, through: :asset

  accepts_nested_attributes_for :real_estate
  validates :cents, :date, presence: true
  before_save :convert_to_cents

  def convert_to_cents
    self.cents = cents * 100
  end
end
