class AddStripeColumns < ActiveRecord::Migration[5.1]
  def change
    add_column :dealerships, :stripe_customer_id, :string
    add_column :dealerships, :stripe_subscription_id, :string
    add_column :dealerships, :most_recent_payment_received_at, :datetime
  end
end
