class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.text :description
      t.integer :amount
      t.hstore :fields
      t.integer :transaction_id

      t.timestamps null: false
    end
  end
end
