class AddSpecialPermissionsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :special_permissions, :string, array: true, default: []
  end
end
