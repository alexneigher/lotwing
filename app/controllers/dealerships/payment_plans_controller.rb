module Dealerships
  class PaymentPlansController < ApplicationController
    
    def create
      @dealership = current_user.dealership
      @errors = []

      token = params[:stripeToken]

      if setup_payment_plan(token)
        #Success
      else
        flash[:error] = @errors.join(', ')
      end

      redirect_to edit_dealership_path(@dealership, anchor: "payment_tab")

    end


    private
      def setup_payment_plan(token)
        customer = create_customer(token)

        if customer.present?
          subscription = create_subscription(customer)
        end

        return @errors.empty?
      end


      def create_customer(token)
        begin
          customer = Stripe::Customer.create(
                      {
                        :email => current_user.email,
                        :source => token
                      }
                    )

        rescue => e
          @errors << e.to_s
          return false
        end

        return nil unless customer

        @dealership.update(stripe_customer_id: customer['id'])

        return customer
      end

      def create_subscription(customer)
        begin
          subscription = Stripe::Subscription.create(
            {
              :customer => customer['id'],
              :collection_method => 'charge_automatically',
              :items => 
                [
                  {
                    :plan => '200_monthly_payment'
                  }
                ]
            }
          )
        rescue => e
          @errors << e.to_s
          return false
        end

        if subscription&.status == "incomplete"
          @errors << "Your card could not be charged. Please try again."
          return nil
        end

        @dealership.update(stripe_subscription_id: subscription['id'], most_recent_payment_received_at: DateTime.now )

        return subscription
      end
  end
end