class ChangeUsersRoleTypeFromStringToInteger < ActiveRecord::Migration
  def change
    change_column :users, :role, 'integer USING CAST(role AS integer)', default: 0, null: false
  end
end
