class CreatePersons < ActiveRecord::Migration
  def change
    create_table :persons do |t|
      t.integer :type, default: 0, null: false
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :phone
      t.string :mobile
      t.hstore :address
      t.integer :account_id

      t.timestamps null: false
    end
  end
end
