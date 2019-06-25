class CreateVehicleUsageType < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :usage_type, :integer
  end
end
