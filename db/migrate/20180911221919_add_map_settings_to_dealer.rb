class AddMapSettingsToDealer < ActiveRecord::Migration[5.1]
  def change
    add_column :dealerships, :map_bearing, :integer
  end
end
