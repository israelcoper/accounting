class AddNewFieldsToProducts < ActiveRecord::Migration
  def change
    add_column :products, :quantity, :integer, default: 0
    add_column :products, :purchasing_price, :decimal, default: 0.00, precision: 10, scale: 2
    add_column :products, :selling_price, :decimal, default: 0.00, precision: 10, scale: 2
  end
end
