class CreateArticles < ActiveRecord::Migration[6.0]
  def change
    create_table :articles do |t|
      t.string :name
      t.string :meta_title
      t.string :meta_description
      t.string :slug
      t.text :content
      t.integer :category
      t.string :author

      t.timestamps
    end
  end
end
