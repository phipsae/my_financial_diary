class ChangeSubcategoryFromIntegerToString < ActiveRecord::Migration[6.0]
  def change
    change_column :assets, :sub_category, :string
  end
end
