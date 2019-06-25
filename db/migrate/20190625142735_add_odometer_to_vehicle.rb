class AddOdometerToVehicle < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :odometer, :string
  end
end
