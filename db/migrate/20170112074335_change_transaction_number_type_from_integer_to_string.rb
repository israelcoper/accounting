class ChangeTransactionNumberTypeFromIntegerToString < ActiveRecord::Migration
  def change
    change_column :transactions, :transaction_number, :string
  end
end
