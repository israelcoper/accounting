class AddAllocatedToSellingAndAllocatedToPurchaseToItems < ActiveRecord::Migration
  def change
    add_column :items, :allocated_to_selling, :integer
    add_column :items, :allocated_to_purchase, :integer
  end
end
