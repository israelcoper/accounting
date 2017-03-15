class ChangeBalanceSheetsCategoryFromStringToInteger < ActiveRecord::Migration
  def change
    change_column :balance_sheets, :category, 'integer USING CAST(category AS integer)', default: 0, null: false
  end
end
