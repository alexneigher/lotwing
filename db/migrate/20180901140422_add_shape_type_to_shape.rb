class AddShapeTypeToShape < ActiveRecord::Migration[5.1]
  def change
    add_column :shapes, :shape_type, :integer
    add_reference :shapes, :dealer
  end
end
