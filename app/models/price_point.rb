class PricePoint < ApplicationRecord
  belongs_to :asset

  validates :cents, :date, presence: true
  before_save :convert_to_cents

  def convert_to_cents
    self.cents = cents * 100
  end
end
