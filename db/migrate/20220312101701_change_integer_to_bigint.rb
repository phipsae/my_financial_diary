class ChangeIntegerToBigint < ActiveRecord::Migration[6.0]
  def change
    change_column :price_points, :cents, :bigint
  end
end
