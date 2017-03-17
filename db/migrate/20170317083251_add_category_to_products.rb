class AddCategoryToProducts < ActiveRecord::Migration
  def change
    add_column :products, :category, :integer, default: 0, null: false
  end
end
