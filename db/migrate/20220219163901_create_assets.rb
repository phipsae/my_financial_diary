class CreateAssets < ActiveRecord::Migration[6.0]
  def change
    create_table :assets do |t|
      t.string :name
      t.integer :sub_category
      t.integer :category
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
