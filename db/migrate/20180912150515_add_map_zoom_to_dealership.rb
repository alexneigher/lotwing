class AddMapZoomToDealership < ActiveRecord::Migration[5.1]
  def change
    add_column :dealerships, :map_zoom, :decimal
  end
end
