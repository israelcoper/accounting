class AddDefaultValueOfItemNumberOfItems < ActiveRecord::Migration
  def change
    change_column :items, :item_number, 'integer USING CAST(item_number AS integer)', default: 10000000, null: false
  end
end
