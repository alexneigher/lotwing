class AddCreationSourceToVehicle < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :creation_source, :integer, default: 0
  end
end
