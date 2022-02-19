class CreatePricePoints < ActiveRecord::Migration[6.0]
  def change
    create_table :price_points do |t|
      t.integer :cents
      t.date :date
      t.text :text
      t.references :asset, null: false, foreign_key: true

      t.timestamps
    end
  end
end
