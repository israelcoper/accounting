class AddQuantityAndRateToItems < ActiveRecord::Migration
  def change
    add_column :items, :quantity, :integer, default: 0
    add_column :items, :rate, :decimal, default: 0.00, precision: 5, scale: 2
  end
end
