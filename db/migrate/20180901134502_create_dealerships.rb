class CreateDealerships < ActiveRecord::Migration[5.1]
  def change
    create_table :dealerships do |t|
      t.string :name

      t.timestamps
    end
  end
end
