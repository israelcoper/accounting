class AddCancelledToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :cancelled, :boolean, null: false, default: false
  end
end
