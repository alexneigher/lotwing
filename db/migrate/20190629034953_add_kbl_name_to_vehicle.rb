class AddKblNameToVehicle < ActiveRecord::Migration[5.1]
  def change
    remove_reference :vehicles, :key_board_location

    add_column :vehicles, :key_board_location_name, :string
  end
end
