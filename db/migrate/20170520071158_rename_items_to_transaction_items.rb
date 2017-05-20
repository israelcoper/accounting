class RenameItemsToTransactionItems < ActiveRecord::Migration
  def change
    rename_table 'items', 'transaction_items'
  end
end
