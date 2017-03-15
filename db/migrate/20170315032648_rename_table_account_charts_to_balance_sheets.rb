class RenameTableAccountChartsToBalanceSheets < ActiveRecord::Migration
  def change
    rename_table 'account_charts', 'balance_sheets'
  end
end
