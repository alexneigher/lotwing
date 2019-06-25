class AddKeyBoardLocationToVehicle < ActiveRecord::Migration[5.1]
  def change
    add_reference :vehicles, :key_board_location
  end
end
