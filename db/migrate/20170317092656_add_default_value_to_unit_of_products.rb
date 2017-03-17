class AddDefaultValueToUnitOfProducts < ActiveRecord::Migration
  def change
    change_column :products, :unit, :string, null: false, default: "none"
  end
end
