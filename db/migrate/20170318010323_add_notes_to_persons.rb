class AddNotesToPersons < ActiveRecord::Migration
  def change
    add_column :persons, :notes, :text
  end
end
