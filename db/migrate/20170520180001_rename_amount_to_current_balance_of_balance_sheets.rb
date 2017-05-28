class RenameAmountToCurrentBalanceOfBalanceSheets < ActiveRecord::Migration
  def change
    rename_column :balance_sheets, :amount, :current_balance
  end
end
