class ChangeIncomeTypeToDecimalOfProducts < ActiveRecord::Migration
  def change
    change_column :products, :income, :decimal, default: 0.00, precision: 5, scale: 2
  end
end
