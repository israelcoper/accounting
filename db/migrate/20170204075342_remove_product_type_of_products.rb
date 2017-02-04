class RemoveProductTypeOfProducts < ActiveRecord::Migration
  def change
    remove_column :products, :product_type
  end
end
