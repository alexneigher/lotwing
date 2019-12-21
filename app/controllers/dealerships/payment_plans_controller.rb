module Dealerships
  class PaymentPlansController < ApplicationController
    
    def create
      @dealership = current_user.dealership
      @errors = []

      token = params[:stripeToken]

      if setup_payment_plan(token)
        #yay
      else
        flash[:error] = @errors.join(', ')
        redirect_to edit_dealership_path(@dealership, anchor: "payment_tab")
      end
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
        end

        return nil unless customer

        #@dealership.update(stripe_customer_id: customer['id'])

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
                ],
            }
          )
        rescue => e
          @errors << e.to_s
        end
        
        return nil unless subscription

        #@dealership.update(stripe_subscription_id: subscription['id'] )

        return subscription
      end
  end
end