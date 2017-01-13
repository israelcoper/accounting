class ChangeCostTypeToDecimalOfProducts < ActiveRecord::Migration
  def change
    change_column :products, :cost, :decimal, default: 0.00, precision: 5, scale: 2
  end
end
