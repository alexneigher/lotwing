class AddDealershipIdToUser < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :dealership
  end
end
