class RemoveParentIdOfCategory < ActiveRecord::Migration
  def change
    remove_column :categories, :parent_id
  end
end
