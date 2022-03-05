class AddCryptoAmountToPricePoints < ActiveRecord::Migration[6.0]
  def change
    add_column :price_points, :crypto_amount, :integer
  end
end
