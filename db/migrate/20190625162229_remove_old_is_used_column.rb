class RemoveOldIsUsedColumn < ActiveRecord::Migration[5.1]
  def change
    remove_column :vehicles, :is_used, :boolean
  end
end
