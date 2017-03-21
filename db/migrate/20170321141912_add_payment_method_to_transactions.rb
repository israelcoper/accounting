class AddPaymentMethodToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :payment_method, :integer, null: false, default: 0
  end
end
