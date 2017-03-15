class DropTableCategories < ActiveRecord::Migration
  def change
    drop_table :categories, force: :cascade
  end
end
