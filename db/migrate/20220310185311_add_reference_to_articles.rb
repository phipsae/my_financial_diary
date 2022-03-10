class AddReferenceToArticles < ActiveRecord::Migration[6.0]
  def change
    remove_reference :articles, :user
  end
end
