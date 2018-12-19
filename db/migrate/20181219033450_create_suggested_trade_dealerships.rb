class CreateSuggestedTradeDealerships < ActiveRecord::Migration[5.1]
  def change
    create_table :suggested_trade_dealerships do |t|
      t.string :name
      t.text :address
      t.string :contact
      t.string :phone
      t.references :dealership
      t.timestamps
    end
  end
end
