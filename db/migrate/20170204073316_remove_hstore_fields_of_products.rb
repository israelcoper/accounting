class RemoveHstoreFieldsOfProducts < ActiveRecord::Migration
  def change
    remove_column :products, :fields
  end
end
