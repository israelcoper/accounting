class RemoveAccountIdOfCategory < ActiveRecord::Migration
  def change
    remove_column :categories, :account_id
  end
end
