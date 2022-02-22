class ChangeMortageToMortgageInRealEstate < ActiveRecord::Migration[6.0]
  def change
    rename_column :real_estates, :mortage, :mortgage
  end
end
