class RemoveSubcategoryOfAccountChart < ActiveRecord::Migration
  def change
    remove_column :account_charts, :subcategory
  end
end
