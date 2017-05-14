class AddHeaderToBalanceSheets < ActiveRecord::Migration
  def change
    add_column :balance_sheets, :header, :boolean, default: false
  end
end
