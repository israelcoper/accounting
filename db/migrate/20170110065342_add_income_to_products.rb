class AddIncomeToProducts < ActiveRecord::Migration
  def change
    add_column :products, :income, :integer
  end
end
