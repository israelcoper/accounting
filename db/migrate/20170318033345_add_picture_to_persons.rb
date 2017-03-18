class AddPictureToPersons < ActiveRecord::Migration
  def change
    add_attachment :persons, :picture
  end
end
