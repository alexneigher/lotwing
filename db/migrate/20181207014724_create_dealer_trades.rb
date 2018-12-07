class CreateDealerTrades < ActiveRecord::Migration[5.1]
  def change
    create_table :dealer_trades do |t|
      t.references :dealership
      
      t.string :trade_dealer_name
      t.text :trade_dealer_address
      t.string :trade_dealer_contact
      t.string :trade_contact_phone

      t.boolean :your_trade, default: false
      t.boolean :our_trade, default: false

      t.boolean :your_purchase, default: false
      t.boolean :our_purchase, default: false



      t.string :date_created
      t.string :time_created
      t.string :desk_manager


      t.string :model
      t.string :color
      t.string :year
      t.string :stock_number
      t.string :vin

      t.text :private_trade_notes

      t.string :delivered_invoice
      t.string :plus_deliver_acc
      t.string :less_rebate_1
      t.string :delivered_total


      t.string :trade_model
      t.string :trade_color
      t.string :trade_year
      t.string :trade_vin
      t.string :trade_stock_number

      t.string :received_invoice
      t.string :received_acc
      t.string :received_rebate
      t.string :received_sum

      t.text :public_trade_notes

      t.string :trade_difference

      t.string :trade_payment_type
      
      t.timestamps
    end
  end
end
