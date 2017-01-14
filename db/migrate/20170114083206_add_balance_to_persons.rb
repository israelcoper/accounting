class AddBalanceToPersons < ActiveRecord::Migration
  def change
    add_column :persons, :balance, :decimal, default: 0.00, precision: 16, scale: 2
  end
end
