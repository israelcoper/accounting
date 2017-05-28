class CreateBalances < ActiveRecord::Migration
  def change
    create_table :balances do |t|
      t.integer :transaction_item_id
      t.integer :balance_sheet_id
      t.decimal :balance, default: 0.0, precision: 16, scale: 2

      t.timestamps null: false
    end
  end
end
