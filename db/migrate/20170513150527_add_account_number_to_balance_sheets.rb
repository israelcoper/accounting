class AddAccountNumberToBalanceSheets < ActiveRecord::Migration
  def change
    add_column :balance_sheets, :account_number, :string
  end
end
