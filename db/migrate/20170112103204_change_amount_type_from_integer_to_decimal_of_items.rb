class ChangeAmountTypeFromIntegerToDecimalOfItems < ActiveRecord::Migration
  def change
    change_column :items, :amount, :decimal, default: 0.00, precision: 5, scale: 2
  end
end
