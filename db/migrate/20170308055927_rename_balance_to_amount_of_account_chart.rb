class RenameBalanceToAmountOfAccountChart < ActiveRecord::Migration
  def change
    rename_column :account_charts, :balance, :amount
  end
end
