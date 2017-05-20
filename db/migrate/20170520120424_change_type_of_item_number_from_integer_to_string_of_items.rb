class ChangeTypeOfItemNumberFromIntegerToStringOfItems < ActiveRecord::Migration
  def change
    change_column :items, :item_number, :string, default: "10000000", null: false
  end
end
