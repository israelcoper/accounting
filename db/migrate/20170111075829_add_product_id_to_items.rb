class AddProductIdToItems < ActiveRecord::Migration
  def change
    add_column :items, :product_id, :integer
  end
end
