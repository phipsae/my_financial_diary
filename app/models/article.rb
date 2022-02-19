class Article < ApplicationRecord
  validates :name, :meta_title, :meta_description, :slug, :content, :category, :author, presence: true
end
