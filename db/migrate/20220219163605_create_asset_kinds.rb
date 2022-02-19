class CreateAssetKinds < ActiveRecord::Migration[6.0]
  def change
    create_table :asset_kinds do |t|
      t.string :sub_category
      t.string :category

      t.timestamps
    end
  end
end
