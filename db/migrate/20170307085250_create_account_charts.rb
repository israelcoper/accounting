class CreateAccountCharts < ActiveRecord::Migration
  def change
    create_table :account_charts do |t|
      t.string :name
      t.string :category
      t.string :subcategory
      t.decimal :balance, default: 0.00, precision: 10, scale: 2

      t.timestamps null: false
    end
  end
end
