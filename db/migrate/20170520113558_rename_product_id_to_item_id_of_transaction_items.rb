class RenameProductIdToItemIdOfTransactionItems < ActiveRecord::Migration
  def change
    rename_column :transaction_items, :product_id, :item_id
  end
end
