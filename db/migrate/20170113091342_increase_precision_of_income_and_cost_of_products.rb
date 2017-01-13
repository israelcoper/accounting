class IncreasePrecisionOfIncomeAndCostOfProducts < ActiveRecord::Migration
  def change
    change_column :products, :cost, :decimal, default: 0.00, precision: 16, scale: 2
    change_column :products, :income, :decimal, default: 0.00, precision: 16, scale: 2
  end
end
