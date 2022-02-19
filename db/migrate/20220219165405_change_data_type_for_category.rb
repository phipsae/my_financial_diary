class ChangeDataTypeForCategory < ActiveRecord::Migration[6.0]
  def change
    change_column :asset_kinds, :category, :integer, using: 'category::integer'
  end
end
