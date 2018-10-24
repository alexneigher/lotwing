class CreateDeals < ActiveRecord::Migration[5.1]
  def change
    create_table :deals do |t|
      t.string :client_last_name
      t.string :source
      t.string :stock_number
      t.string :trade
      t.string :sales_rep
      t.string :split_rep
      t.string :city
      t.string :model
      t.string :make
      t.boolean :is_used, defult: false
      t.string :year
      t.string :result
      t.string :report_status
      t.string :deal_number
      t.string :pay_method
      t.string :deal_type
      t.decimal :selling_price
      t.decimal :down_payment
      t.string :term
      t.decimal :quoted_payment
      t.string :rate_apr
      t.string :miles_per_year
      t.string :rebates
      t.string :program_description
      t.string :desk_manager
      t.string :finance_manager
      t.boolean :dealer_demo, default: false
      t.boolean :loaner_car, default: false
      t.string :discloser
      t.decimal :trade_allowance
      t.decimal :trade_acv
      t.decimal :trade_payoff_amount
      t.string :trade_bank_name
      t.date :good_through_date
      t.string :trade_account_number
      t.text :send_payoff_address
      t.string :time_agreed
      t.string :time_in_finance
      t.string :time_out_finance

      t.references :dealership
      t.timestamps
    end
  end
end
