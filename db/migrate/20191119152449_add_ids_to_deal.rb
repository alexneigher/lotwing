class AddIdsToDeal < ActiveRecord::Migration[5.1]
  def change
    add_reference :deals, :sales_rep
    add_reference :deals, :split_rep
  end
end
