class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer :product_type, default: 0, null: false
      t.string :name
      t.hstore :fields
      t.integer :account_id

      t.timestamps null: false
    end
  end
end
