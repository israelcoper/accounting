class RemoveFieldsColumnOfItems < ActiveRecord::Migration
  def change
    remove_column :items, :fields
  end
end
