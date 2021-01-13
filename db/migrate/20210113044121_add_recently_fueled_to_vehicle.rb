class AddRecentlyFueledToVehicle < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :recently_fueled, :boolean, default: false
  end
end
