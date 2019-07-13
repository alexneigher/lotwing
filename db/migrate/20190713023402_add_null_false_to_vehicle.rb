class AddNullFalseToVehicle < ActiveRecord::Migration[5.1]
  def change
    change_column :vehicles, :mileage, :integer, default: 0, null: false
    change_column :vehicles, :age_in_days, :integer, default: 0, null: false
  end
end
