class DropOdometerFromVehicles < ActiveRecord::Migration[5.1]
  def change
    remove_column :vehicles, :odometer, :string
  end
end
