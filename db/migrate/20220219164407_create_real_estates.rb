class CreateRealEstates < ActiveRecord::Migration[6.0]
  def change
    create_table :real_estates do |t|
      t.string :address
      t.integer :sqm
      t.integer :price_per_sqm
      t.integer :mortgage
      t.references :asset, null: false, foreign_key: true

      t.timestamps
    end
  end
end
