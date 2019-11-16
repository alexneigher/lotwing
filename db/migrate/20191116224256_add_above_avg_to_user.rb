class AddAboveAvgToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :sales_rep_above_monthly_moving_average, :boolean, default: false
  end
end
