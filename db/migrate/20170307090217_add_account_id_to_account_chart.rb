class AddAccountIdToAccountChart < ActiveRecord::Migration
  def change
    add_column :account_charts, :account_id, :integer
  end
end
