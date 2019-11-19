class DropUnusedColumns < ActiveRecord::Migration[5.1]
  def change
    remove_column :deals, :sales_rep
    remove_column :deals, :split_rep
  end
end
