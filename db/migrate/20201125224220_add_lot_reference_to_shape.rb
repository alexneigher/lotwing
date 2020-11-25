class AddLotReferenceToShape < ActiveRecord::Migration[5.1]
  def change
    add_reference :shapes, :parking_lot
  end
end
