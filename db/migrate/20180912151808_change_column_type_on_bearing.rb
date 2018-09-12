class ChangeColumnTypeOnBearing < ActiveRecord::Migration[5.1]
  def change
    change_column :dealerships, :map_bearing, :decimal
  end
end
