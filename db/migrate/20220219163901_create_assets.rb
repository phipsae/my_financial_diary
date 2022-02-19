class CreateAssets < ActiveRecord::Migration[6.0]
  def change
    create_table :assets do |t|
      t.string :name
      t.references :user, null: false, foreign_key: true
      t.references :asset_kind, null: false, foreign_key: true

      t.timestamps
    end
  end
end
