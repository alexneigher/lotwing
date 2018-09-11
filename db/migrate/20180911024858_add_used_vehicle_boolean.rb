class AddUsedVehicleBoolean < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :is_used, :boolean, default: :false
  end
end
