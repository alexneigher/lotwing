class AddHolds < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :service_hold, :boolean, default: false
    add_column :vehicles, :sales_hold, :boolean, default: false 
    add_column :vehicles, :service_hold_notes, :text
    add_column :vehicles, :sales_hold_notes, :text

    add_column :vehicles, :sold_status, :string
  end
end
