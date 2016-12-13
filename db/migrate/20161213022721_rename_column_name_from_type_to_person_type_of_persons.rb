class RenameColumnNameFromTypeToPersonTypeOfPersons < ActiveRecord::Migration
  def change
    rename_column :persons, :type, :person_type
  end
end
