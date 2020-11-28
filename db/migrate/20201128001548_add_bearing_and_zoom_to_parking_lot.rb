class AddBearingAndZoomToParkingLot < ActiveRecord::Migration[5.1]
  def change
    add_column :parking_lots, :map_bearing, :decimal
    add_column :parking_lots, :map_zoom, :decimal
  end
end
