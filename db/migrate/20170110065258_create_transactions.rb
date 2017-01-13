class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :transaction_type
      t.integer :transaction_number
      t.datetime :transaction_date
      t.datetime :due_date
      t.text :notes
      t.string :status
      t.integer :payment
      t.integer :balance
      t.integer :total
      t.integer :account_id
      t.integer :person_id
      t.integer :parent_id

      t.timestamps null: false
    end
  end
end
