class RenameProductNumberToItemNumberofItems < ActiveRecord::Migration
  def change
    rename_column :items, :product_number, :item_number
  end
end
