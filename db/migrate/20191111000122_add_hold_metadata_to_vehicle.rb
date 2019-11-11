class AddHoldMetadataToVehicle < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :sales_hold_creator, :string
    add_column :vehicles, :service_hold_creator, :string

    add_column :vehicles, :sales_hold_created_at, :datetime
    add_column :vehicles, :service_hold_created_at, :datetime
  end
end
