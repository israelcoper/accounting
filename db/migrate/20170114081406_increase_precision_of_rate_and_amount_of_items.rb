class IncreasePrecisionOfRateAndAmountOfItems < ActiveRecord::Migration
  def change
    change_column :items, :rate, :decimal, default: 0.00, precision: 8, scale: 2
    change_column :items, :amount, :decimal, default: 0.00, precision: 16, scale: 2
  end
end
