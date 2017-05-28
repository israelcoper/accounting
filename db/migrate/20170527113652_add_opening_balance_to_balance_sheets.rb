class AddOpeningBalanceToBalanceSheets < ActiveRecord::Migration
  def change
    add_column :balance_sheets, :opening_balance, :decimal, default: 0.0, precision: 10, scale: 2
  end
end
