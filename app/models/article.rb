class Article < ApplicationRecord
  enum category: { cash: 0, securities: 1, real_estate: 2, raw_materials: 3, crypto: 4, cars: 5, others: 6 }

  validates :name, :meta_title, :meta_description, :slug, :content, :category, :author, presence: true
end
