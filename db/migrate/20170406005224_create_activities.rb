class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :name
      t.integer :user_id
      t.integer :transaction_id

      t.timestamps null: false
    end
  end
end
