class RemoveNameAndDescriptionOfItems < ActiveRecord::Migration
  def change
    remove_column :items, :name, :string
    remove_column :items, :description, :text
  end
end
