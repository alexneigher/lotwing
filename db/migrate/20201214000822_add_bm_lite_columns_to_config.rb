class AddBmLiteColumnsToConfig < ActiveRecord::Migration[5.1]
  def change
    add_column :dealership_configurations, :use_full_board_manager, :boolean, default: true
    add_column :dealership_configurations, :use_sales_rep_averages, :boolean, default: true
  end
end
