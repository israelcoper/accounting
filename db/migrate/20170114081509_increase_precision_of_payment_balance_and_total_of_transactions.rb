class IncreasePrecisionOfPaymentBalanceAndTotalOfTransactions < ActiveRecord::Migration
  def change
    change_column :transactions, :payment, :decimal, default: 0.00, precision: 16, scale: 2
    change_column :transactions, :balance, :decimal, default: 0.00, precision: 16, scale: 2
    change_column :transactions, :total, :decimal, default: 0.00, precision: 16, scale: 2
  end
end
