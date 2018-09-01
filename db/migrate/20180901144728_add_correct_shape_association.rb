class AddCorrectShapeAssociation < ActiveRecord::Migration[5.1]
  def change
    remove_reference :shapes, :dealer
    add_reference :shapes, :dealership
  end
end
